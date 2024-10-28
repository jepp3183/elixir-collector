import Config

config :prometheus,
  collectors: [
    Metrics.Collectors.JellyfinCollector,
    Metrics.Collectors.PlexCollector,
    Metrics.Collectors.SmartWeather,
    :prometheus_boolean,
    :prometheus_counter,
    :prometheus_gauge,
    :prometheus_histogram,
    :prometheus_mnesia_collector,
    :prometheus_quantile_summary,
    :prometheus_summary,
    :prometheus_vm_dist_collector,
    :prometheus_vm_memory_collector,
    :prometheus_vm_msacc_collector,
    :prometheus_vm_statistics_collector,
    :prometheus_vm_system_info_collector,
  ]
