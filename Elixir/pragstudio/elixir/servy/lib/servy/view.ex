defmodule Servy.View do
  require EEx

  alias Servy.Conv

  @templates_path Path.expand("templates", File.cwd!())
  def templates_path, do: @templates_path

  def render(%Conv{} = conv, template, bindings \\ []) do
    content =
      templates_path()
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, body: content}
  end
end
