defmodule TelemetricsTest do
  use ExUnit.Case
  doctest Telemetrics

  test "greets the world" do
    assert Telemetrics.hello() == :world
  end
end
