defmodule HttpServerTest do
  use ExUnit.Case, async: true

  import Servy.HttpServer, only: [start: 1]

  test "accept /bears request on a socket and return appropriate response" do
    pid = spawn(fn -> start(4000) end)

    {:ok, %{body: body}} = HTTPoison.get("http://localhost:4000/bears")

    expected_response = """
    <h1>All The Bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(body) == remove_whitespace(expected_response)

    Process.exit(pid, :kill)
  end

  test "test concurrent server request handling" do
    pid = spawn(fn -> start(4000) end)

    1..5
    |> Enum.map(fn _ -> Task.async(fn -> HTTPoison.get("http://localhost:4000/wildthings") end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(&verify_wildthings_resp/1)

    Process.exit(pid, :kill)
  end

  test "test concurrent server request handling of different GET urls" do
    pid = spawn(fn -> start(4000) end)

    ["wildthings", "about", "bears", "api/bears", "bears/new"]
    |> Enum.map(&Task.async(fn -> HTTPoison.get("http://localhost:4000/#{&1}") end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn {:ok, %{status_code: sc}} -> assert sc == 200 end)

    Process.exit(pid, :kill)
  end

  defp verify_wildthings_resp({:ok, %{status_code: sc, body: b}}) do
    assert sc == 200
    assert b == "Bears, Lions, Tigers"
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
