defmodule App do
  use Application

  def start(_type, _args) do
    Metrics.ScrapeCountMetric.setup()
    Metrics.MainExporter.setup()

    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: 4040]}
    ]

    opts = [strategy: :one_for_one, name: Application.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
