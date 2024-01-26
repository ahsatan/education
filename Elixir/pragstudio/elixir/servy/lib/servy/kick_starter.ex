defmodule Servy.KickStarter do
  use GenServer

  @name __MODULE__

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting the kick starter..."
    GenServer.start_link __MODULE__, :ok, name: @name
  end

  def get_server do
    GenServer.call @name, :get_server
  end

  # Server Callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttpServer exited: #{inspect reason}"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    port = Application.get_env(:servy, :port)
    spawn_link Servy.HttpServer, :start, [port]
  end
end
