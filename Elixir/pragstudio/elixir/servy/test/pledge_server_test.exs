defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  import Servy.PledgeServer, only: [start: 0, create_pledge: 2, recent_pledges: 0, total_pledged: 0]

  test "cache entries (up to 3) are overriden, oldest first" do
    pid = start()

    create_pledge("ron", 10)
    create_pledge("remus", 100)
    create_pledge("sirius", 200)
    create_pledge("hermione", 300)
    create_pledge("harry", 400)

    assert recent_pledges() == [{"harry", 400}, {"hermione", 300}, {"sirius", 200}]

    Process.exit(pid, :kill)
  end

  test "total of cached pledges" do
    pid = start()

    create_pledge("sirius", 200)
    create_pledge("hermione", 300)
    create_pledge("harry", 400)

    assert total_pledged() == 900

    Process.exit(pid, :kill)
  end
end
