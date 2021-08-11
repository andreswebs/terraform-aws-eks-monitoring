module "monitoring_iam" {
  source                      = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/iam"
  cluster_oidc_provider       = var.cluster_oidc_provider
  loki_storage_s3_bucket_name = var.loki_storage_s3_bucket_name
}
