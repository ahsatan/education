defmodule Servy.FileHandler do
  alias Servy.Conv

  def handle_file({:ok, content}, conv = %Conv{}) do
    %{conv | status: 200, body: content}
  end

  def handle_file({:error, :enoent}, conv = %Conv{}) do
    %{conv | status: 404, body: "File not found!"}
  end

  def handle_file({:error, reason}, conv = %Conv{}) do
    %{conv | status: 500, body: "File error: #{reason}"}
  end
end
