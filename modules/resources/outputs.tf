output "namespace" {
  description = "The name (`metadata.name`) of the Kubernetes namespace"
  value       = local.namespace
}

output "svc" {
  description = "Local Kubernetes service FQDNs"
  value = {
    grafana    = var.grafana_enabled ? local.grafana_svc : null
    loki       = var.loki_enabled ? local.loki_svc : null
    prometheus = var.prometheus_enabled ? local.prom_svc : null
  }
}

output "release" {
  description = "Helm releases"
  value = {
    metrics_server = local.release_metrics_server
    loki           = local.release_loki
    log_aggregator = local.release_aggregator
    grafana        = local.release_grafana
    prometheus     = local.release_prometheus
  }
}
