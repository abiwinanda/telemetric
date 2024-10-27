defmodule Telemetrics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Telemetrics.Telemetry.ReporterState, {0, 0}},
      Telemetrics.Telemetry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Telemetrics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
