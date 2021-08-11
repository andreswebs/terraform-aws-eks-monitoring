module "monitoring_resources" {
  source = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/resources"

  loki_iam_role_arn           = var.loki_iam_role_arn
  loki_compactor_iam_role_arn = var.loki_compactor_iam_role_arn
  grafana_iam_role_arn        = var.grafana_iam_role_arn

  loki_storage_s3_bucket_name = var.loki_storage_s3_bucket_name

  chart_version_loki_distributed = var.chart_version_loki_distributed
  chart_version_promtail         = var.chart_version_promtail
  chart_version_prometheus       = var.chart_version_prometheus
  chart_version_grafana          = var.chart_version_grafana

  grafana_enabled = true

}