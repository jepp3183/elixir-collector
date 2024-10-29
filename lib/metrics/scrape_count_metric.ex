defmodule Metrics.ScrapeCountMetric do
  use Prometheus.Metric

  def setup() do
    Counter.declare(
      name: :scrape_count,
      labels: [],
      help: "Number of times the /metrics endpoint has been hit"
    )
  end

  def inc() do
    Counter.inc(name: :scrape_count)
  end
end
