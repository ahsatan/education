defmodule Servy.Bear do
  @derive {Jason.Encoder, only: [:id, :name, :type, :hibernating]}
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end

  def compare(bear1, bear2) do
    bear1.name <= bear2.name
  end
end
