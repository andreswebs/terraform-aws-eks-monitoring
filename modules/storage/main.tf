resource "aws_kms_key" "this" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "Encryption key for log storage"
  enable_key_rotation     = var.kms_key_enable_rotation
  deletion_window_in_days = var.kms_key_deletion_window_in_days
}

resource "aws_kms_alias" "this" {
  count         = var.create_kms_key && var.kms_key_alias != "" ? 1 : 0
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.this[0].key_id
}

locals {
  s3_bucket_name_norm = var.s3_bucket_name == "" ? null : var.s3_bucket_name
  s3_bucket_name      = var.create_s3_id_suffix ? (local.s3_bucket_name_norm != null ? "${local.s3_bucket_name_norm}-${random_id.id[0].hex}" : "loki-storage-${random_id.id[0].hex}") : local.s3_bucket_name_norm
  kms_key_arn_norm    = var.kms_key_arn == "" ? null : var.kms_key_arn
  kms_key_arn         = var.create_kms_key ? aws_kms_key.this[0].arn : local.kms_key_arn_norm
  sse_algorithm       = local.kms_key_arn == null ? "AES256" : "aws:kms"
  expire_objects      = var.expiration_days != 0
}

resource "random_id" "id" {
  count       = var.create_s3_id_suffix ? 1 : 0
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  bucket = local.s3_bucket_name
  acl    = "private"

  force_destroy = var.s3_force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = local.kms_key_arn
        sse_algorithm     = local.sse_algorithm
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.expire_objects ? [1] : []
    content {

      id      = "expire"
      enabled = true

      tags = {
        rule      = "expire"
        autoclean = "true"
      }

      expiration {
        days = var.expiration_days
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

