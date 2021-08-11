resource "random_id" "id" {
  count       = var.create_loki_storage_id_suffix ? 1 : 0
  byte_length = 8
}

locals {
  s3_bucket_name_norm = var.loki_storage_s3_bucket_name == "" ? null : var.loki_storage_s3_bucket_name
  s3_bucket_name      = var.create_loki_storage_id_suffix ? (local.s3_bucket_name_norm != null ? "${local.s3_bucket_name_norm}-${random_id.id[0].hex}" : "loki-storage-${random_id.id[0].hex}") : local.s3_bucket_name_norm
}

resource "aws_s3_bucket" "loki_storage" {
  count  = var.create_loki_storage ? 1 : 0
  bucket = local.s3_bucket_name
  acl    = "private"

  force_destroy = true

  ## TODO: enable customer manager key
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "loki_storage" {
  count                   = var.create_loki_storage ? 1 : 0
  bucket                  = aws_s3_bucket.loki_storage[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  loki_storage_s3_bucket_name = var.create_loki_storage ? aws_s3_bucket.loki_storage[0].id : (local.s3_bucket_name == null ? "" : local.s3_bucket_name)
}
