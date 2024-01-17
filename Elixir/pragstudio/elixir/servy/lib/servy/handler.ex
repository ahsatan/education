defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]

  alias Servy.Conv
  alias Servy.View
  alias Servy.BearController
  alias Servy.PledgeController
  alias Servy.VideoCam
  alias Servy.Tracker
  alias Servy.FourOhFourCounter

  # mix always uses root project directory as cwd
  @pages_path Path.expand("pages", File.cwd!())

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path()
    |> log()
    |> route
    |> track()
    |> calc_content_length
    |> format_response
  end

  defp route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  defp route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = FourOhFourCounter.get_counts()

    %{conv | status: 200, body: inspect counts}
  end

  defp route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()

    %{conv | status: 200, body: "Awake!"}
  end

  defp route(%Conv{method: "POST", path: "/pledges"} = conv) do
    PledgeController.create(conv, conv.params)
  end

  defp route(%Conv{method: "GET", path: "/pledges"} = conv) do
    PledgeController.index(conv)
  end

  defp route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    PledgeController.new(conv)
  end

  defp route(%Conv{method: "GET", path: "/sensors"} = conv) do
    bf_task = Task.async(fn -> Tracker.get_location("bigfoot") end)

    snapshots =
    1..3
    # instead of anon function, can pass MFA (module, function, args) to certain functions
    |> Enum.map(&Task.async(VideoCam, :get_snapshot, ["cam-#{&1}"]))
    |> Enum.map(&Task.await/1)

    bf_tracker = Task.await(bf_task)

    View.render(conv, "sensors.eex", snapshots: snapshots, tracker: bf_tracker)
  end

  # same arity function clauses pattern match (clunkier than haskell/ML PM)
  defp route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    # syntactic sugar | only allows changing existing fields
    %{conv | status: 200, body: "Bears, Lions, Tigers"}
  end

  defp route(%Conv{method: "GET", path: "/about"} = conv) do
    route_file("about.html", conv)
  end

  defp route(%Conv{method: "GET", path: "/pages/faq"} = conv) do
    body =
      @pages_path
      |> Path.join("faq.md")
      |> File.read!()
      |> Earmark.as_html!()

    %Conv{conv | status: 200, body: body}
  end

  defp route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    route_file(page <> ".html", conv)
  end

  defp route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  defp route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    route_file("form.html", conv)
  end

  defp route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    BearController.show(conv, Map.put(conv.params, "id", id))
  end

  defp route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    BearController.delete(conv, Map.put(conv.params, "id", id))
  end

  defp route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  defp route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  defp route(%Conv{method: "POST", path: "/api/bears", params: params} = conv) do
    Servy.Api.BearController.create(conv, params)
  end

  defp route(%Conv{path: path} = conv) do
    %{conv | status: 404, body: "No #{path} here."}
  end

  defp route_file(filename, %Conv{} = conv) do
    @pages_path
    |> Path.join(filename)
    |> File.read()
    |> handle_file(conv)
  end

  defp calc_content_length(%Conv{} = conv) do
    Conv.add_resp_header(conv, "Content-Length", byte_size(conv.body))
  end

  defp format_response(%Conv{} = conv) do
    # map.field is syntactic sugar for map[:field]
    # byte_size instead of String.length b/c some UTF-8 chars > 1 byte
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.body}
    """
  end

  defp format_response_headers(%Conv{} = conv) do
    conv.resp_headers
    |> Enum.map(fn {k, v} -> "#{k}: #{v}\r" end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
