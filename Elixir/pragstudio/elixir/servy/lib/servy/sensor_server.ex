defmodule Servy.SensorServer do
  use GenServer

  @name __MODULE__

  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.hours(1)
  end

  # Client Interface

  def start_link(interval) do
    IO.puts "Starting the sensor server..."
    GenServer.start_link __MODULE__, %State{refresh_interval: interval}, name: @name
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  def set_refresh_interval(interval) do
    GenServer.cast @name, {:set_refresh_interval, interval}
  end

  # Server Callbacks

  def init(state) do
    data = run_tasks_to_get_sensor_data()
    schedule_refresh(state.refresh_interval)
    {:ok, %{state | sensor_data: data}}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  # changes interval AFTER next refresh
  def handle_cast({:set_refresh_interval, interval}, state) do
    {:noreply, %{state | refresh_interval: interval}}
  end

  def handle_info(:refresh, state) do
    data = run_tasks_to_get_sensor_data()
    schedule_refresh(state.refresh_interval)
    {:noreply, %{state | sensor_data: data}}
  end

  def handle_info(message, state) do
    IO.puts "Unexpected message received: #{inspect message}"
    {:noreply, state}
  end

  defp schedule_refresh(interval) do
    Process.send_after self(), :refresh, interval
  end

  defp run_tasks_to_get_sensor_data do
    bf_task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
    1..3
    |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot("cam-#{&1}") end))
    |> Enum.map(&Task.await/1)

    bf_tracker = Task.await(bf_task)

    %{snapshots: snapshots, tracker: bf_tracker}
  end
end
