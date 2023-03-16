output "role" {
  description = "IAM roles"
  value = {
    grafana        = var.grafana_enabled ? aws_iam_role.grafana[0] : null
    loki           = var.loki_enabled ? aws_iam_role.loki[0] : null
    loki_compactor = var.loki_enabled ? aws_iam_role.loki_compactor[0] : null
  }
}
