# Telemetrics

Simple elixir telemetry_metrics app.

## Setup

First, install the dependencies.

```
mix deps.get
```

then run iex with mix.

```
iex -S mix
```

See the telemetry instrumenter/handler in action by calling a function that emit a telemetry event.

```
iex(1)> emit.(10)
Metric: Elixir.Telemetry.Metrics.Counter. Current value: 1
Metric: Elixir.Telemetry.Metrics.Sum. Current value: 10
:ok

iex(2)> emit.(20)
Metric: Elixir.Telemetry.Metrics.Counter. Current value: 2
Metric: Elixir.Telemetry.Metrics.Sum. Current value: 30
:ok
```
