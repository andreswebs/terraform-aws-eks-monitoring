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

variable "loki_storage_s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket used for Loki storage"
  default     = ""
}

variable "loki_k8s_sa_name" {
  type        = string
  description = "Name of the Kubernetes service account for Loki components"
  default     = "loki"
}

variable "loki_compactor_k8s_sa_name" {
  type        = string
  description = "Name of the Kubernetes service account for the Loki compactor"
  default     = "loki-compactor"
}

variable "grafana_k8s_sa_name" {
  type        = string
  description = "Name of the Kubernetes service account for Grafana"
  default     = "grafana"
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
