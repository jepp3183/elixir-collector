defmodule App do
  use Application
  
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: 4040]}
    ]

    Metrics.MainExporter.setup()

    collectors = [
      Metrics.Collectors.SmartWeather,
      Metrics.Collectors.PlexCollector
    ]
    collectors |> Enum.each(&Prometheus.Registry.register_collector(&1))
    

    opts = [strategy: :one_for_one, name: Application.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
