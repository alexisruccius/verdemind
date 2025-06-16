defmodule VerdemindWeb.TelemetryTest do
  use ExUnit.Case

  describe "metrics/0" do
    test "returns a list of Telemetry.Metrics.Summary structs" do
      assert [%Telemetry.Metrics.Summary{} | _] = VerdemindWeb.Telemetry.metrics()
    end
  end
end
