defmodule Servy.Plugins do
  require Logger

  alias Servy.Conv
  alias Servy.FourOhFourCounter

  def rewrite_path(conv = %Conv{path: "/wildlife"}) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv = %Conv{path: path}) do
    rewrite_path_captures(conv, Regex.named_captures(~r{\/(?<thing>\w+)\?id=(?<id>\d+)}, path))
  end

  defp rewrite_path_captures(conv = %Conv{}, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(conv = %Conv{}, nil), do: conv

  def log(conv = %Conv{}) do
    if Mix.env() == :dev do
      IO.puts("Log:\n")
      IO.inspect(conv)
    end

    conv
  end

  @doc "Logs 404 requests."
  def track(conv = %Conv{path: path, status: 404}) do
    if Mix.env() != :test do
      Logger.warning("#{path} is on the loose!")
      FourOhFourCounter.bump_count(path)
    end

    conv
  end

  def track(conv = %Conv{}), do: conv
end
