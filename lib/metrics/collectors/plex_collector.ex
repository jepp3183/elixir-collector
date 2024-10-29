defmodule Metrics.Collectors.PlexCollector do
  use Metrics.Collectors.ApiCollector

  # Helpers
  defp get_title(session) do
    if session["type"] == "episode" do
      "#{session["grandparentTitle"]} - s#{session["parentIndex"]}e#{session["index"]}: #{session["title"]}"
    else
      session["title"]
    end
  end

  # Impl 
  @impl true
  def build_request() do
    Req.new(url: "#{System.fetch_env!("PLEX_URL")}/status/sessions")
    |> Req.Request.put_header("X-Plex-Token", System.fetch_env!("PLEX_TOKEN"))
    |> Req.Request.put_header("Accept", "application/json")
  end

  @impl true
  def build_mfs(response) do
    [
      {:plex_session_count, "Number of active Plex sessions", :gauge,
       response.body["MediaContainer"]["size"]},
      {:plex_session_info, "Plex session info", :gauge, response}
    ]
  end

  @impl true
  def collect_metrics(:plex_session_info, data) do
    sessions = data.body["MediaContainer"]["Metadata"] || []

    sessions
    |> Enum.map(fn session ->
      [
        user: session["User"]["title"],
        title: get_title(session),
        state: session["Player"]["state"],
        type: session["type"],
        client: session["Player"]["product"],
        device: session["Player"]["title"],
        direct_playing: session["TranscodeSession"]["videoDecision"] != "transcode"
      ]
    end)
    |> Enum.map(&{&1, 1})
    |> Prometheus.Model.gauge_metrics()
  end

  @impl true
  def collect_metrics(_name, data) do
    Prometheus.Model.gauge_metric([], data)
  end
end
