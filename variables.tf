variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
  default     = ""
}

variable "k8s_namespace" {
  type        = string
  description = "Name of the Kubernetes namespace to which resources will be deployed"
  default     = "monitoring"
}

variable "metrics_server_enabled" {
  type        = bool
  description = "Enable Metrics Server?"
  default     = true
}

variable "prometheus_enabled" {
  type        = bool
  description = "Enable Prometheus?"
  default     = true
}

variable "loki_enabled" {
  type        = bool
  description = "Enable Loki?"
  default     = true
}

variable "grafana_enabled" {
  type        = bool
  description = "Enable Grafana?"
  default     = true
}

variable "loki_mode" {
  type        = string
  description = "Loki mode, must be either `single` or `distributed`"
  default     = "distributed"
  validation {
    condition     = can(regex("^single|distributed$", var.loki_mode))
    error_message = "Must be one of `single` or `distributed`."
  }
}

variable "loki_aggregator" {
  type        = string
  description = "Loki aggregator to install, must be either `promtail` or `fluent-bit`"
  default     = "promtail"
  validation {
    condition     = can(regex("^promtail|fluent-bit", var.loki_aggregator))
    error_message = "Must be one of `promtail` or `fluent-bit`."
  }
}

variable "loki_iam_role_name" {
  type        = string
  description = "Name of IAM role for Loki"
  default     = "loki"
}

variable "loki_compactor_iam_role_name" {
  type        = string
  description = "Name of IAM role for Loki Compactor"
  default     = "loki-compactor"
}

variable "create_loki_storage" {
  type        = bool
  description = "Create S3 bucket for Loki storage?"
  default     = false
}

variable "create_loki_storage_id_suffix" {
  type        = bool
  description = "Append a random identifier string suffix to the Loki storage S3 bucket name?"
  default     = false
}

variable "create_loki_storage_kms_key" {
  type        = bool
  description = "Create KMS key?"
  default     = true
}

variable "loki_storage_s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket used for Loki storage"
  default     = ""
}

variable "loki_storage_s3_force_destroy" {
  type        = bool
  description = "Force destroy bucket when running `terraform destroy`?"
  default     = true
}

variable "loki_storage_kms_key_arn" {
  type        = string
  description = "(Optional) ARN of KMS key used to encrypt bucket objects; ignored if `create_kms_key` is set to `true`"
  default     = null
}

variable "loki_storage_kms_key_deletion_window_in_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 30
}

variable "loki_storage_kms_key_enable_rotation" {
  type        = bool
  description = "Enable KMS key rotation?"
  default     = true
}

variable "loki_storage_expiration_days" {
  type        = number
  description = "Number of days to retain objects; `0` means never expire"
  default     = 90
}

variable "loki_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Loki components"
  default     = "loki"
}

variable "loki_compactor_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for the Loki compactor"
  default     = "loki-compactor"
}

variable "grafana_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Grafana"
  default     = "grafana"
}

variable "grafana_iam_role_name" {
  type        = string
  description = "Name of IAM role for Grafana"
  default     = "grafana"
}

## chart versions

variable "chart_version_metrics_server" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_prometheus" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_promtail" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_loki_distributed" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_grafana" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_fluent_bit" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "chart_version_loki" {
  type        = string
  description = "Chart version"
  default     = null
}

## end chart versions

## helm

variable "helm_release_name_metrics_server" {
  type        = string
  description = "Release name"
  default     = "metrics-server"
}

variable "helm_release_name_prometheus" {
  type        = string
  description = "Release name"
  default     = "prometheus"
}

variable "helm_release_name_grafana" {
  type        = string
  description = "Release name"
  default     = "grafana"
}

variable "helm_release_name_loki" {
  type        = string
  description = "Release name"
  default     = "loki"
}

variable "helm_release_name_promtail" {
  type        = string
  description = "Release name"
  default     = "promtail"
}

variable "helm_release_name_fluent_bit" {
  type        = string
  description = "Release name"
  default     = "fluent-bit"
}

variable "helm_max_history" {
  type        = number
  description = "Maximum number of release versions stored per release; `0` means no limit"
  default     = 3
}

variable "helm_timeout_seconds" {
  type        = number
  description = "Time in seconds to wait for any individual kubernetes operation"
  default     = 300
}

variable "helm_recreate_pods" {
  type        = bool
  description = "Perform pods restart during upgrade/rollback ?"
  default     = true
}

variable "helm_atomic_creation" {
  type        = bool
  description = "Purge resources on installation failure ? The wait flag will be set automatically if atomic is used"
  default     = true
}

variable "helm_cleanup_on_fail" {
  type        = bool
  description = "Deletion new resources created in this upgrade if the upgrade fails ?"
  default     = true
}

variable "helm_wait_for_completion" {
  type        = bool
  description = "Wait until all resources are in a ready state before marking the release as successful ?"
  default     = true
}

variable "helm_wait_for_jobs" {
  type        = bool
  description = "Wait until all Jobs have been completed before marking the release as successful ?"
  default     = true
}

variable "helm_verify" {
  type        = bool
  description = "Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart"
  default     = false
}

variable "helm_keyring" {
  type        = string
  description = "Location of public keys used for verification; used only if verify is true"
  default     = ".gnupg/pubring.gpg"
}

variable "helm_reuse_values" {
  type        = bool
  description = "When upgrading, reuse the last release's values and merge any overrides ? If 'reset_values' is specified, this is ignored"
  default     = false
}

variable "helm_reset_values" {
  type        = bool
  description = "When upgrading, reset the values to the ones built into the chart ?"
  default     = false
}

variable "helm_force_update" {
  type        = bool
  description = "Force resource update through delete/recreate if needed ?"
  default     = false
}

variable "helm_create_namespace" {
  type        = bool
  description = "Create the namespace if it does not yet exist ?"
  default     = true
}

variable "helm_replace" {
  type        = bool
  description = "Re-use the given name, even if that name is already used; this is unsafe in production"
  default     = false
}

variable "helm_dependency_update" {
  type        = bool
  description = "Run helm dependency update before installing the chart ?"
  default     = false
}

variable "helm_skip_crds" {
  type        = bool
  description = "Skip installing CRDs ?"
  default     = false
}

## end helm
