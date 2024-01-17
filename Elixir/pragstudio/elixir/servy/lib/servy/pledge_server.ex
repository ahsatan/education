defmodule Servy.GenServer do
  # Client

  def start(callback_module, initial_state, name) do
    pid = spawn __MODULE__, :listen_loop, [initial_state, callback_module]
    Process.register pid, name
    pid
  end

  # Client Helpers

  def call(pid, message) do
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  # Server

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call message, state
        send sender, {:response, response}
        listen_loop new_state, callback_module
      {:cast, message} ->
        new_state = callback_module.handle_cast message, state
        listen_loop new_state, callback_module
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop state, callback_module
    end
  end
end

defmodule Servy.PledgeServer do
  alias Servy.GenServer

  @name __MODULE__ # unique pid name

  # Client Functions

  def start(state \\ []) do
    GenServer.start(__MODULE__, state, @name)
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

  # Server Callback Functions

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service name, amount
    new_state = [{name, amount} | Enum.take(state, 2)]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    total = state |> Enum.map &elem(&1, 1) |> Enum.sum()
    {total, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  defp send_pledge_to_service(_name, _amount) do
    # FAKE: EXTERNAL SERVICE CALL

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
