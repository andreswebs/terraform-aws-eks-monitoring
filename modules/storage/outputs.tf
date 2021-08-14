output "bucket" {
  description = "S3 bucket"
  value       = aws_s3_bucket.this
}

output "encryption_key" {
  description = "KMS key used for encryption, if created"
  value       = var.create_kms_key ? aws_kms_key.this[0] : null
}
