defmodule ScrapeCountPlug do
  def init(opts), do: opts

  def call(conn, _opts) do
  %Plug.Conn{request_path: path} = conn
  IO.puts path

  case path do 
  "/metrics" -> Metrics.ScrapeMetric.inc()
  _ -> nil
  end

  conn
  end
end

