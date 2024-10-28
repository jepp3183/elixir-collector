defmodule Metrics.Collectors.JellyfinCollector do
  use Metrics.Collectors.ApiCollector

  # Helpers
  defp get_title(session) do
    item = session["NowPlayingItem"]

    if item["Type"] == "Episode" do
      "#{item["SeriesName"]} - s#{item["ParentIndexNumber"]}e#{item["IndexNumber"]}: #{item["Name"]}"
    else
      item["Name"]
    end
  end

  # Impl 
  @impl true
  def build_request() do
    Req.new(url: "https://media.jeppeallerslev.dk/Sessions", params: [ActiveWithinSeconds: 15])
    |> Req.Request.put_header(
      "Authorization",
      "MediaBrowser Token=#{System.fetch_env!("JELLYFIN_TOKEN")}"
    )
    |> Req.Request.put_header("Accept", "application/json")
  end

  @impl true
  def build_mfs(response) do
    [
      {:jellyfin_session_count, "Number of active Jellyfin sessions", :gauge,
       length(response.body)},
      {:jellyfin_session_info, "Jellyfin session info", :gauge, response}
    ]
  end

  @impl true
  def collect_metrics(:jellyfin_session_info, data) do
    sessions = data.body || []

    sessions
    |> Enum.filter(fn session -> session["NowPlayingItem"] != nil end)
    |> Enum.map(fn session ->
      [
        user: session["UserName"],
        title: get_title(session),
        state: if(session["PlayState"]["IsPaused"], do: "paused", else: "playing"),
        type: String.downcase(session["NowPlayingItem"]["Type"]),
        client: session["Client"],
        device: session["DeviceName"],
        direct_playing: session["TranscodingInfo"]["IsVideoDirect"]
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
