defmodule Router do
  use Plug.Router

  plug Metrics.MainExporter
  plug :match  # Plug that finds matching route
  plug :dispatch  # Plug that calls the matching route from above

  get "/" do
    send_resp(conn, 200, "Root!")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end 
end
