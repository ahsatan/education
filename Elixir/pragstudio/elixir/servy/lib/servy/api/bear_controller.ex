defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(conv = %Conv{}) do
    json =
      Servy.Wildthings.bears()
      |> Jason.encode!()

    conv
    |> Conv.add_resp_header("Content-Type", "application/json")
    |> Map.put(:status, 200)
    |> Map.put(:body, json)
  end

  def create(conv = %Conv{}, %{"type" => type, "name" => name}) do
    %{conv | status: 201, body: "Created a #{type} bear named #{name}!"}
  end
end
