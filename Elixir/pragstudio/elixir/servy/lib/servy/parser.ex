defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\r\n\r\n")
    [request_line | headers] = String.split(top, "\r\n")
    [method, path, _] = String.split(request_line)
    headers = parse_headers(headers)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: parse_params(headers["Content-Type"], body)
    }
  end

  @doc false
  def parse_headers(headers) do
    headers
    |> Enum.map(&parse_header/1)
    |> List.foldl(%{}, fn [k, v], acc -> Map.put(acc, k, v) end)
  end

  @doc false
  def parse_header(header) do
    String.split(header, ": ")
  end

  @doc false
  def parse_params("application/x-www-form-urlencoded", body) do
    body
    |> String.trim()
    |> URI.decode_query()
  end

  @doc false
  def parse_params("application/json", body) do
    Jason.decode!(body)
  end

  @doc false
  def parse_params(_, _), do: %{}
end
