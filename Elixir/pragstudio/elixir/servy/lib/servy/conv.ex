# Each module can only hold one struct as struct is named after module!
defmodule Servy.Conv do
  @moduledoc "Conversation holding HTTP response."
  alias __MODULE__

  defstruct method: "",
            path: "",
            headers: %{},
            params: %{},
            status: nil,
            resp_headers: %{"Content-Type" => "text/html"},
            body: ""

  def add_resp_header(conv = %Conv{}, key, value) do
    %{conv | resp_headers: Map.put(conv.resp_headers, key, value)}
  end

  def full_status(conv = %Conv{}) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
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
