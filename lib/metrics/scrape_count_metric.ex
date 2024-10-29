defmodule Metrics.ScrapeMetric do
  use Prometheus.Metric

  @counter [
    name: :scrape_count,
    labels: [],
    help: "Number of times the /metrics endpoint has been hit",
  ]

  def inc() do
    Counter.inc([name: :scrape_count])
  end
end
