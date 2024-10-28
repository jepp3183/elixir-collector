defmodule Metrics.Collectors.WeatherCollector do
  require Logger
  use Prometheus.Collector

  @url "https://api.open-meteo.com/v1/forecast?latitude=56.1567&longitude=10.2108&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,wind_gusts_10m&wind_speed_unit=ms&timezone=Europe%2FBerlin"

  # metric name, help text, response key
  @metrics [
    {:weather_temperature_c, "Temperature in Aarhus", "temperature_2m"},
    {:weather_humidity_relative, "Relative humidity in Aarhus", "relative_humidity_2m"},
    {:weather_apparent_temperature_c, "Apparent temperature in Aarhus", "apparent_temperature"},
    {:weather_wind_speed_ms, "Wind speed in Aarhus", "wind_speed_10m"},
    {:weather_wind_gusts_ms, "Wind gusts in Aarhus", "wind_gusts_10m"}
  ]

  def handle_response({:ok, res}, callback) do
    current = res.body["current"]

    for {name, help, key} <- @metrics do
      g =
        Prometheus.Model.create_mf(
          name,
          help,
          :gauge,
          __MODULE__,
          current[key]
        )

      callback.(g)
    end
  end

  def handle_response({:error, reason}, _callback) do
    Logger.error("Weather API request failed: #{inspect(reason)}")
  end

  @impl true
  def collect_mf(_registry, callback) do
    handle_response(Req.get(@url), callback)
    :ok
  end

  def collect_metrics(_name, val) do
    Prometheus.Model.gauge_metric([], val)
  end
end
