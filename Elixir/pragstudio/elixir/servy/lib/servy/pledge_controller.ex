defmodule Servy.PledgeController do
  import Servy.View

  alias Servy.Conv
  alias Servy.PledgeServer

  def create(%Conv{} = conv, %{"name" => n, "amount" => amt}) do
    PledgeServer.create_pledge(n, String.to_integer(amt))

    %{conv | status: 201, body: "#{n} pledged #{amt}!"}
  end

  def index(%Conv{} = conv) do
    pledges = PledgeServer.recent_pledges()

    render(conv, "recent_pledges.eex", pledges: pledges)
  end

  def new(%Conv{} = conv) do
    render(conv, "new_pledge.eex")
  end
end
