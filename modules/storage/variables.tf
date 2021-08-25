variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket created for Loki storage"
  default     = ""
}

variable "create_s3_bucket_id_suffix" {
  type        = bool
  description = "Append a random identifier string suffix to the Loki storage S3 bucket name?"
  default     = false
}

variable "s3_force_destroy" {
  type        = bool
  description = "Force destroy bucket when running `terraform destroy`?"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "(Optional) ARN of KMS key used to encrypt bucket objects; ignored if `create_kms_key` is set to `true`"
  default     = null
}

variable "kms_key_alias" {
  type = string
  description = "(Optional) An alias for the generated KMS key; must start with `alias/`"
  default = ""
  validation {
    condition = var.kms_key_alias == "" || (length(var.kms_key_alias) > 6 && substr(var.kms_key_alias, 0, 6) == "alias/")
    error_message = "Must start with `alias/` ."
  }
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 30
}

variable "kms_key_enable_rotation" {
  type        = bool
  description = "Enable KMS key rotation?"
  default     = true
}

variable "create_kms_key" {
  type        = bool
  description = "Create KMS key?"
  default     = true
}

variable "expiration_days" {
  type        = number
  description = "Number of days to retain objects; `0` means never expire"
  default     = 0
}
