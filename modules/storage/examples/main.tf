module "log_storage" {
  source         = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/storage"
  s3_bucket_name = var.loki_storage_s3_bucket_name

}
