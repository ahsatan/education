defmodule ParserTest do
  use ExUnit.Case, async: true

  alias Servy.Parser

  test "parse_header" do
    header = "User-Agent: ExampleBrowser/1.0"

    parsed = Parser.parse_header(header)

    assert parsed == ["User-Agent", "ExampleBrowser/1.0"]
  end

  test "parse_headers none" do
    parsed = Parser.parse_headers([])

    assert parsed == %{}
  end

  test "parse_headers multiple" do
    headers = ["K1: V1", "K2: V2"]

    parsed = Parser.parse_headers(headers)

    assert parsed == %{"K1" => "V1", "K2" => "V2"}
  end

  test "parse_params application/x-www-form-urlencoded" do
    params = "name=Baloo&type=Brown"
    content_type = "application/x-www-form-urlencoded"

    result = Parser.parse_params(content_type, params)

    assert result == %{"name" => "Baloo", "type" => "Brown"}
  end

  test "parse_params invalid content type" do
    params = "name=Baloo&type=Brown"
    content_type = "multipart/form-data"

    result = Parser.parse_params(content_type, params)

    assert result == %{}
  end
end
