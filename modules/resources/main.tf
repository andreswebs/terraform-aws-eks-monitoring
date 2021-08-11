/**
* Deploys Helm charts and other resources.
*
* **Note**: This module depends on an imperative deployment of Metrics Server:
* ```sh
* kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
* ```
*/

terraform {
  required_version = ">= 1.0.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.48.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }

  }
}

data "aws_region" "current" {}

locals {
  prom_svc     = "prometheus-server.${var.k8s_namespace}.svc.cluster.local"
  loki_svc     = var.loki_mode == "distributed" ? "loki-distributed-gateway.${var.k8s_namespace}.svc.cluster.local" : "loki.${var.k8s_namespace}.svc.cluster.local:3100"
  grafana_svc  = "grafana.${var.k8s_namespace}.svc.cluster.local"
  has_bucket   = local.loki_storage_s3_bucket_name != "" ## --> defined in `loki-distributed.tf`
  loki_enabled = var.loki_enabled && (local.has_bucket || var.loki_mode == "single")
}

resource "helm_release" "prometheus" {
  count      = var.prometheus_enabled ? 1 : 0
  name       = var.helm_release_name_prometheus
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.k8s_namespace
  version    = var.chart_version_prometheus

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    file("${path.module}/helm-values/prometheus.yml")
  ]

}

resource "helm_release" "grafana" {
  count      = var.grafana_enabled ? 1 : 0
  name       = var.helm_release_name_grafana
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.k8s_namespace
  version    = var.chart_version_grafana

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    templatefile("${path.module}/helm-values/grafana.yml.tpl", {
      aws_region                   = data.aws_region.current.name
      prom_svc                     = local.prom_svc
      loki_svc                     = local.loki_svc
      grafana_service_account_name = var.grafana_service_account_name
      grafana_iam_role_arn         = var.grafana_iam_role_arn
    })
  ]

}

resource "helm_release" "loki" {
  count      = local.loki_enabled && var.loki_mode == "single" ? 1 : 0
  name       = var.helm_release_name_loki
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace  = var.k8s_namespace
  version    = var.chart_version_loki

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    file("${path.module}/helm-values/loki.yml")
  ]
}

resource "helm_release" "loki_distributed" {
  count      = var.loki_enabled && var.loki_mode == "distributed" ? 1 : 0
  name       = var.helm_release_name_loki
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-distributed"
  namespace  = var.k8s_namespace
  version    = var.chart_version_loki_distributed

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    templatefile("${path.module}/helm-values/loki-distributed.yml.tpl", {
      aws_region                          = data.aws_region.current.name
      bucket_name                         = local.loki_storage_s3_bucket_name
      loki_iam_role_arn                   = var.loki_iam_role_arn
      loki_service_account_name           = var.loki_service_account_name
      loki_compactor_iam_role_arn         = var.loki_compactor_iam_role_arn
      loki_compactor_service_account_name = var.loki_compactor_service_account_name
    })
  ]
}

resource "helm_release" "fluent_bit" {
  count      = var.loki_enabled && var.loki_aggregator == "fluent-bit" ? 1 : 0
  name       = var.helm_release_name_fluent_bit
  repository = "https://grafana.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = var.k8s_namespace
  version    = var.chart_version_fluent_bit

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    templatefile("${path.module}/helm-values/fluent-bit.yml.tpl", {
      loki_svc = replace(local.loki_svc, ":3100", "")
    })
  ]

}

resource "helm_release" "promtail" {
  count      = var.loki_enabled && var.loki_aggregator == "promtail" ? 1 : 0
  name       = var.helm_release_name_promtail
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = var.k8s_namespace
  version    = var.chart_version_promtail

  recreate_pods     = var.helm_recreate_pods
  atomic            = var.helm_atomic_creation
  cleanup_on_fail   = var.helm_cleanup_on_fail
  wait              = var.helm_wait_for_completion
  wait_for_jobs     = var.helm_wait_for_jobs
  timeout           = var.helm_timeout_seconds
  max_history       = var.helm_max_history
  verify            = var.helm_verify
  keyring           = var.helm_keyring
  reuse_values      = var.helm_reuse_values
  reset_values      = var.helm_reset_values
  force_update      = var.helm_force_update
  replace           = var.helm_replace
  create_namespace  = var.helm_create_namespace
  dependency_update = var.helm_dependency_update
  skip_crds         = var.helm_skip_crds

  values = [
    templatefile("${path.module}/helm-values/promtail.yml.tpl", {
      loki_address = "http://${local.loki_svc}/loki/api/v1/push"
    })
  ]

}

locals {
  release_grafana    = var.grafana_enabled ? helm_release.grafana[0] : null
  release_prometheus = var.prometheus_enabled ? helm_release.prometheus[0] : null
  release_loki       = local.loki_enabled ? (var.loki_mode == "distributed" ? helm_release.loki_distributed[0] : helm_release.loki[0]) : null
  release_aggregator = local.loki_enabled ? (var.loki_aggregator == "promtail" ? helm_release.promtail[0] : helm_release.fluent_bit[0]) : null
  namespace          = var.prometheus_enabled ? local.release_prometheus.metadata[0].namespace : (var.grafana_enabled ? local.release_grafana.metadata[0].namespace : (local.loki_enabled ? local.release_loki.metadata[0].namespace : null))
}
