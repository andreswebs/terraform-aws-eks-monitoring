/**
* Deploys the "Grafana + Prometheus + Loki" monitoring stack via Helm on AWS EKS.
*
* **Note**: This module depends on an imperative deployment of Metrics Server:
* ```sh
* kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
* ```
*/

resource "random_id" "id" {
  count       = var.create_loki_storage_id_suffix ? 1 : 0
  byte_length = 8
}

locals {
  s3_bucket_name_norm = var.loki_storage_s3_bucket_name == "" ? null : var.loki_storage_s3_bucket_name
  s3_bucket_name_pre  = var.create_loki_storage_id_suffix ? (local.s3_bucket_name_norm != null ? "${local.s3_bucket_name_norm}-${random_id.id[0].hex}" : "loki-storage-${random_id.id[0].hex}") : local.s3_bucket_name_norm
}

module "log_storage" {
  count                           = var.create_loki_storage ? 1 : 0
  source                          = "./modules/storage"
  s3_force_destroy                = var.loki_storage_s3_force_destroy
  s3_bucket_name                  = local.s3_bucket_name
  create_s3_bucket_id_suffix      = var.create_loki_storage_id_suffix
  create_kms_key                  = var.create_loki_storage_kms_key
  kms_key_arn                     = var.loki_storage_kms_key_arn
  kms_key_deletion_window_in_days = var.loki_storage_kms_key_deletion_window_in_days
  kms_key_enable_rotation         = var.loki_storage_kms_key_enable_rotation
  expiration_days                 = var.loki_storage_expiration_days
}

locals {
  s3_bucket_name = var.create_loki_storage ? module.log_storage[0].bucket.id : (local.s3_bucket_name_pre == null ? "" : local.s3_bucket_name_pre)
  kms_key_arn    = var.create_loki_storage_kms_key ? module.log_storage[0].encryption_key.arn : var.loki_storage_kms_key_arn
}

module "iam" {
  source = "./modules/iam"

  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_namespace         = var.k8s_namespace

  loki_k8s_sa_name           = var.loki_k8s_sa_name
  loki_compactor_k8s_sa_name = var.loki_compactor_k8s_sa_name
  grafana_k8s_sa_name        = var.grafana_k8s_sa_name

  loki_iam_role_name           = var.loki_iam_role_name
  loki_compactor_iam_role_name = var.loki_compactor_iam_role_name
  grafana_iam_role_name        = var.grafana_iam_role_name

  loki_storage_s3_bucket_name = local.s3_bucket_name
  loki_storage_kms_key_arn    = local.kms_key_arn

  grafana_enabled = var.grafana_enabled
  loki_enabled    = var.loki_enabled
}

module "resources" {
  source = "./modules/resources"

  k8s_namespace = var.k8s_namespace

  loki_k8s_sa_name           = var.loki_k8s_sa_name
  loki_compactor_k8s_sa_name = var.loki_compactor_k8s_sa_name
  grafana_k8s_sa_name        = var.grafana_k8s_sa_name

  loki_iam_role_arn           = var.loki_enabled ? module.iam.role.loki.arn : null
  loki_compactor_iam_role_arn = var.loki_enabled ? module.iam.role.loki_compactor.arn : null
  grafana_iam_role_arn        = var.grafana_enabled ? module.iam.role.grafana.arn : null

  loki_storage_s3_bucket_name = local.s3_bucket_name

  chart_version_prometheus       = var.chart_version_prometheus
  chart_version_promtail         = var.chart_version_promtail
  chart_version_loki_distributed = var.chart_version_loki_distributed
  chart_version_grafana          = var.chart_version_grafana
  chart_version_fluent_bit       = var.chart_version_fluent_bit
  chart_version_loki             = var.chart_version_loki

  helm_release_name_prometheus = var.helm_release_name_prometheus
  helm_release_name_grafana    = var.helm_release_name_grafana
  helm_release_name_loki       = var.helm_release_name_loki
  helm_release_name_promtail   = var.helm_release_name_promtail
  helm_release_name_fluent_bit = var.helm_release_name_fluent_bit

  helm_recreate_pods     = var.helm_recreate_pods
  helm_atomic            = var.helm_atomic_creation
  helm_cleanup_on_fail   = var.helm_cleanup_on_fail
  helm_wait              = var.helm_wait_for_completion
  helm_wait_for_jobs     = var.helm_wait_for_jobs
  helm_timeout           = var.helm_timeout_seconds
  helm_max_history       = var.helm_max_history
  helm_verify            = var.helm_verify
  helm_keyring           = var.helm_keyring
  helm_reuse_values      = var.helm_reuse_values
  helm_reset_values      = var.helm_reset_values
  helm_force_update      = var.helm_force_update
  helm_replace           = var.helm_replace
  helm_create_namespace  = var.helm_create_namespace
  helm_dependency_update = var.helm_dependency_update
  helm_skip_crds         = var.helm_skip_crds

}
