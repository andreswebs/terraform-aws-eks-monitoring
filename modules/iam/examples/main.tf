module "monitoring_iam" {
  source = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/iam"

  cluster_oidc_provider = var.eks_cluster_oidc_provider

  loki_iam_role_name           = "loki-${var.eks_cluster_id}"
  loki_compactor_iam_role_name = "loki-compactor-${var.eks_cluster_id}"
  grafana_iam_role_name        = "grafana-${var.eks_cluster_id}"

  loki_storage_s3_bucket_name = var.loki_storage_s3_bucket_name
}