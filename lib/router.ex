defmodule Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(ScrapeCountPlug)
  plug(Metrics.MainExporter)

  # Plug that finds matching route
  plug(:match)
  # Plug that calls the matching route from above
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hi!")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
