defmodule Metrics.Collectors.SmartWeather do
  use Metrics.Collectors.ApiCollector

  @impl true
  def build_request() do
   "https://api.open-meteo.com/v1/forecast?latitude=56.1567&longitude=10.2108&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,wind_gusts_10m&wind_speed_unit=ms&timezone=Europe%2FBerlin"
  end

  @impl true
  def build_mfs(response) do
    current = response.body["current"]
    [
      {:weather_temperature_c, "Temperature in Aarhus", :gauge, current["temperature_2m"]},
      {:weather_humidity_relative, "Relative humidity in Aarhus", :gauge, current["relative_humidity_2m"]},
      {:weather_apparent_temperature_c, "Apparent temperature in Aarhus", :gauge, current["apparent_temperature"]},
      {:weather_wind_speed_ms, "Wind speed in Aarhus", :gauge, current["wind_speed_10m"]},
      {:weather_wind_gusts_ms, "Wind gusts in Aarhus", :gauge, current["wind_gusts_10m"]}
    ]
  end

  @impl true
  def collect_metrics(_name, data) do
    Prometheus.Model.gauge_metric([], data)
  end
end
