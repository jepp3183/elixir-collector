defmodule Metrics.Collectors.ApiCollector do
  @moduledoc """
  A behaviour for creating collectors that fetch data from an API. Currently made for only a single API request.
  If more advanced functionality is required, use Prometheus.Collector
  """

  @callback build_request :: Req.Request.t() | String.t()

  @doc """
  Build metrics from the response body. Should return list of {:metric_name, help text, type, data} 
  This will define the metric FAMILIES in the collector
  """
  @callback build_mfs(Req.Response.t()) :: [{atom, String.t(), atom, any}]

  @doc """
  Collect metrics from the response body. Should return list of {:metric_name, data}
  This will define the actual metrics in the collector using labels
  """
  @callback collect_metrics(atom, any) :: any

  defmacro __using__(_opts) do
    quote do
      require Logger
      use Prometheus.Collector

      @behaviour unquote(__MODULE__)

      @impl true
      def collect_mf(_registry, callback) do
        case Req.get(build_request()) do
          {:ok, res} ->
            build_mfs(res)
            |> Enum.map(fn {name, help, type, value} ->
                Prometheus.Model.create_mf(name, help, type, __MODULE__, value)
              end)
            |> Enum.each(&callback.(&1))

          {:error, reason} ->
            Logger.error("API request for #{__MODULE__} failed: #{inspect(reason)}")
        end

        :ok
      end
    end
  end
end
