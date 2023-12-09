defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  defp log(conv), do: IO.inspect(conv)

  defp parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split()

    %{method: method, path: path, status: nil, resp_body: ""}
  end

  defp rewrite_path(conv = %{path: "/wildlife"}) do
    %{conv | path: "/wildthings"}
  end

  defp rewrite_path(conv = %{path: path}) do
    rewrite_path_captures(conv, Regex.named_captures(~r{\/(?<thing>\w+)\?id=(?<id>\d+)}, path))
  end

  defp rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(conv, nil), do: conv

  # same arity function clauses pattern match (clunkier than haskell/ML PM)
  defp route(conv = %{method: "GET", path: "/wildthings"}) do
    # syntactic sugar | only allows changing existing fields
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  defp route(conv = %{method: "GET", path: "/bears"}) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  defp route(conv = %{method: "GET", path: "/bears/" <> id}) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  defp route(conv = %{method: "DELETE", path: "/bears/" <> id}) do
    %{conv | status: 403, resp_body: "You can't delete Bear #{id} (or any bear)!"}
  end

  defp route(conv = %{path: path}) do
    %{conv | status: 404, resp_body: "No #{path} here."}
  end

  defp track(conv = %{path: path, status: 404}) do
    Logger.warning("#{path} is on the loose!")
    conv
  end

  defp track(conv), do: conv

  defp emojify(conv = %{status: 200, resp_body: resp_body}) do
    %{conv | resp_body: "🎉 #{resp_body} 🎉"}
  end

  defp emojify(conv), do: conv

  defp format_response(conv) do
    # map.field is syntactic sugar for map[:field] where field is an atom
    # byte_size instead of String.length b/c some UTF-8 chars > 1 byte
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    # keys are numbers not atoms so use normal syntax ( => )
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request_wild = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_wildlife = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears_1 = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bears_id_1 = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

delete_bears_1 = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_bigfoot = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request_wild))
IO.puts(Servy.Handler.handle(request_wildlife))
IO.puts(Servy.Handler.handle(request_bears))
IO.puts(Servy.Handler.handle(request_bigfoot))
IO.puts(Servy.Handler.handle(request_bears_1))
IO.puts(Servy.Handler.handle(request_bears_id_1))
IO.puts(Servy.Handler.handle(delete_bears_1))
