variable "cluster_oidc_provider" {
  type        = string
  description = "OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster"
}

variable "k8s_namespace" {
  type        = string
  description = "Name of the Kubernetes namespace to which resources will be deployed"
  default     = "monitoring"
}

## loki

variable "loki_enabled" {
  type        = bool
  description = "Enable Loki?"
  default     = true
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

variable "loki_storage_s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket used for Loki storage"
  default     = ""
}

## end loki

## grafana

variable "grafana_enabled" {
  type        = bool
  description = "Enable Grafana?"
  default     = true
}

variable "grafana_k8s_sa_name" {
  type        = string
  description = "Name of the Kubernetes service account for Grafana"
  default     = "grafana"
}

variable "grafana_iam_role_name" {
  type        = string
  description = "Name of IAM role for Grafana"
  default     = "grafana"
}

## end grafana
