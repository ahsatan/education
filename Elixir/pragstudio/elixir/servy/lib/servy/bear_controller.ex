defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Bear
  alias Servy.Wildthings
  alias Servy.BearView

  def index(conv = %Conv{}) do
    %{conv | status: 200, body: BearView.index(Enum.sort(Wildthings.bears(), &Bear.compare/2))}
  end

  def show(conv = %Conv{}, %{"id" => id}) do
    %{conv | status: 200, body: BearView.show(Wildthings.get_bear(id))}
  end

  def create(conv = %Conv{}, %{"type" => type, "name" => name}) do
    %{conv | status: 201, body: "Created a #{type} bear named #{name}!"}
  end

  def delete(conv = %Conv{}, %{"id" => id}) do
    %{conv | status: 403, body: "You can't delete Bear #{id} (or any bear)!"}
  end
end
