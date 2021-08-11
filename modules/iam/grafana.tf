locals {
  grafana_iam_role_name = var.grafana_iam_role_name == "" ? null : var.grafana_iam_role_name
}

module "grafana_assume_role_policy" {
  count                 = var.grafana_enabled ? 1 : 0
  source                = "andreswebs/eks-irsa-policy-document/aws"
  version               = "1.0.0"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.grafana_k8s_sa_name
  k8s_sa_namespace      = var.k8s_namespace
}

resource "aws_iam_role" "grafana" {
  count                 = var.grafana_enabled ? 1 : 0
  name                  = local.grafana_iam_role_name
  assume_role_policy    = module.grafana_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "grafana_permissions" {
  count  = var.grafana_enabled ? 1 : 0
  name   = "grafana-permissions"
  role   = aws_iam_role.grafana[0].id
  policy = file("${path.module}/policies/grafana-permissions.json")
}
