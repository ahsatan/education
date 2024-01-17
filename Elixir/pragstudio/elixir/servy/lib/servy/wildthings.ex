defmodule Servy.Wildthings do
  alias Servy.Bear

  @db_path Path.expand("lib/servy/db", File.cwd!())

  def bears do
    @db_path
    |> Path.join("bears.json")
    |> File.read!()
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear
  end
end
