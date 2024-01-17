defmodule Servy.BearView do
  require EEx

  alias Servy.View

  EEx.function_from_file(:def, :index, Path.join(View.templates_path(), "index.eex"), [:bears])

  EEx.function_from_file(:def, :show, Path.join(View.templates_path(), "show.eex"), [:bear])
end
