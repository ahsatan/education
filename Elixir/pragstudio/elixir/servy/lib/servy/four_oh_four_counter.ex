defmodule Servy.GenServer2 do
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
        new_state = callback_module.handle_info unexpected, state
        listen_loop new_state, callback_module
    end
  end
end

defmodule Servy.FourOhFourCounter do
  alias Servy.GenServer2

  @name __MODULE__

  def start(state \\ %{}) do
    GenServer2.start __MODULE__, state, @name
  end

  def bump_count(path) do
    GenServer2.call @name, {:bump_count, path}
  end

  def get_count(path) do
    GenServer2.call @name, {:get_count, path}
  end

  def get_counts do
    GenServer2.call @name, :get_counts
  end

  def reset do
    GenServer2.cast @name, :reset
  end

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update state, path, 1, &(&1 + 1) # Elixirism for fn c -> c + 1 end
    count = Map.get new_state, path
    {count, new_state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get state, path, 0
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end

  def handle_info(message, state) do
    IO.puts "Unexpected message: #{inspect message}"
    state
  end
end
