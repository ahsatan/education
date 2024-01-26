defmodule Servy.PledgeServer do
  use GenServer # like inheritance, override only desired functions

  @name __MODULE__ # unique pid name

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting the pledge server..."
    GenServer.start_link __MODULE__, %State{}, name: @name # returns {:ok, pid}
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do
    GenServer.cast @name, :clear
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server Callbacks

  # init's param is second argument given to GenServer.start, state in this case
  # start blocks until this returns
  def init(state) do
    {:ok, %{state | pledges: fetch_recent_pledges_from_service()}}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service name, amount
    pledges = [{name, amount} | Enum.take(state.pledges, state.cache_size - 1)]
    {:reply, id, %{state | pledges: pledges}}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = state.pledges |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    pledges = Enum.take(state.pledges, size) # if increased, would need to hit service
    {:noreply, %{state | cache_size: size, pledges: pledges}}
  end

  def handle_info(message, state) do
    IO.puts "Can't touch this! #{inspect message}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # FAKE: EXTERNAL SERVICE CALL

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # FAKE: EXTERNAL SERVICE CALL

    [{"gabe", 15}, {"ada", 25}]
  end
end
