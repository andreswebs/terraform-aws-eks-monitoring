output "namespace" {
  description = "The name (`metadata.name`) of the Kubernetes namespace"
  value       = local.namespace
}

output "loki_storage" {
  description = "The Loki storage S3 bucket, if created"
  value       = var.create_loki_storage ? aws_s3_bucket.loki_storage[0] : null
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
    loki           = local.release_loki
    log_aggregator = local.release_aggregator
    grafana        = local.release_grafana
    prometheus     = local.release_prometheus
  }
}
