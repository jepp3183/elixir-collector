defmodule Metrics.TestMetric do
  use Prometheus.Metric

  @gauge [
      name: :test_gauge,
      help: "Gauge for testing",
      labels: ["test_label"]
    ]

  def set(value) do
    Gauge.set(:test_gauge, value)
  end

  def inc(lbl) do
    Gauge.inc([
      name: :test_gauge,
      labels: [lbl]
    ])
  end
end
