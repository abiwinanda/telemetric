defmodule Telemetrics.Telemetry.CustomReporter do
  use GenServer

  alias Telemetrics.Telemetry.ReporterState
  alias Telemetry.Metrics

  def start_link(metrics: metrics) do
    GenServer.start_link(__MODULE__, metrics)
  end

  @impl true
  def init(metrics) do
    Process.flag(:trap_exit, true)

    groups = Enum.group_by(metrics, & &1.event_name)

    for {event, metrics} <- groups do
      id = {__MODULE__, event, self()}
      :telemetry.attach(id, event, &__MODULE__.handle_event/4, metrics)
    end

    {:ok, Map.keys(groups)}
  end

  def handle_event(_event_name, measurements, metadata, metrics) do
    Enum.map(metrics, &handle_metric(&1, measurements, metadata))
  end

  defp handle_metric(%Metrics.Counter{} = metric, _measurements, _metadata) do
    ReporterState.increment()

    {current_counter, _} = ReporterState.value()

    IO.puts("Metric: #{metric.__struct__}. Current value: #{current_counter}")
  end

  defp handle_metric(%Metrics.Sum{} = metric, %{value: value}, _metadata) do
    ReporterState.sum(value)

    {_, current_sum} = ReporterState.value()

    IO.puts("Metric: #{metric.__struct__}. Current value: #{current_sum}")
  end

  defp handle_metric(metric, _measurements, _metadata) do
    IO.puts("Unsupported metric: #{metric.__struct__}")
  end

  @impl true
  def terminate(_, events) do
    for event <- events do
      :telemetry.detach({__MODULE__, event, self()})
    end

    :ok
  end
end
