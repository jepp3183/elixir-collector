defmodule Metrics.Collectors.PlexCollector do
  use Metrics.Collectors.ApiCollector

  @impl true
  def build_request() do
    Req.new(url: "https://plex.jeppeallerslev.dk/status/sessions")
    |> Req.Request.put_header("X-Plex-Token", System.get_env("PLEX_TOKEN"))
    |> Req.Request.put_header("Accept", "application/json")
  end

  @impl true
  def build_mfs(response) do
    [
      {:plex_session_count, "Number of active Plex sessions", :gauge, response.body["MediaContainer"]["size"]},
      {:plex_session_info, "Number of active Plex sessions", :gauge, response}
    ]
  end

  @impl true
  def collect_metrics(:plex_session_info, data) do
    sessions = data.body["MediaContainer"]["Metadata"] || []
    sessions
    |> Enum.map(fn session ->
      [
        user: session["User"]["title"],
        title: session["title"],
        state: session["Player"]["state"]
      ]
    end)
    |> Enum.map(&({&1, 1}))
    |> Prometheus.Model.gauge_metrics()
    
  end

  @impl true
  def collect_metrics(_name, data) do
    Prometheus.Model.gauge_metric([], data)
  end
end
