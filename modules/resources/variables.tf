variable "k8s_namespace" {
  type        = string
  description = "Name of a Kubernetes namespace which will be created for deploying the resources"
  default     = "monitoring"
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
  default     = false
}

variable "loki_mode" {
  type = string
  description = "Loki mode, must be either `single` or `distributed`"
  default = "distributed"
  validation {
    condition = can(regex("^single|distributed$", var.loki_mode))
    error_message = "Must be one of `single` or `distributed`."
  }
}

variable "loki_aggregator" {
  type = string
  description = "Loki aggregator to install, must be either `promtail` or `fluent-bit`"
  default = "promtail"
  validation {
    condition = can(regex("^promtail|fluent-bit", var.loki_aggregator))
    error_message = "Must be one of `promtail` or `fluent-bit`."
  }
}

variable "loki_storage_s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket created for Loki storage"
  default     = ""
}

variable "loki_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Loki components"
  default     = "loki-distributed"
}

variable "loki_iam_role_arn" {
  type        = string
  description = "Loki IAM role ARN"
  default     = ""
}

variable "loki_compactor_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for the Loki compactor"
  default     = "loki-compactor"
}

variable "loki_compactor_iam_role_arn" {
  type        = string
  description = "Loki compactor IAM role ARN"
  default     = ""
}

variable "grafana_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account for Grafana"
  default     = "grafana"
}

variable "grafana_iam_role_arn" {
  type        = string
  description = "Grafana IAM role ARN"
  default     = ""
}

## chart versions

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