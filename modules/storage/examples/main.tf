module "log_storage" {
  source         = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/storage"
  s3_bucket_name = var.loki_storage_s3_bucket_name
  s3_force_destroy = true
  create_kms_key   = true
  expiration_days  = 365
}