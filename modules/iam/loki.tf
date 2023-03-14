locals {
  loki_enabled  = var.loki_enabled && var.loki_storage_s3_bucket_name != "" && var.loki_storage_s3_bucket_name != null
  kms_enabled   = var.loki_enabled && var.loki_storage_kms_key_arn != "" && var.loki_storage_kms_key_arn != null
  s3_bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${var.loki_storage_s3_bucket_name}"
}

## policy documents

data "aws_iam_policy_document" "bucket_crud" {
  count = local.loki_enabled ? 1 : 0

  statement {
    sid = "AllowListObjects"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      local.s3_bucket_arn
    ]
  }

  statement {
    sid = "AllowObjectsCRUD"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${local.s3_bucket_arn}/*"
    ]
  }

}

data "aws_iam_policy_document" "kms_permissions" {
  count = local.kms_enabled ? 1 : 0
  statement {
    sid = "AllowUseKey"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [var.loki_storage_kms_key_arn]
  }
}

locals {
  loki_permission_documents = compact([
    (local.loki_enabled ? data.aws_iam_policy_document.bucket_crud[0].json : ""),
    (local.kms_enabled ? data.aws_iam_policy_document.kms_permissions[0].json : "")
  ])
}

data "aws_iam_policy_document" "loki_permissions" {
  count = local.loki_enabled ? 1 : 0
  source_policy_documents = local.loki_permission_documents
}

## end policy documents

## loki role

locals {
  loki_iam_role_name = var.loki_iam_role_name == "" ? null : var.loki_iam_role_name
}

module "loki_assume_role_policy" {
  count                 = local.loki_enabled ? 1 : 0
  source                = "andreswebs/eks-irsa-policy-document/aws"
  version               = "~> 1.0"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_k8s_sa_name
  k8s_sa_namespace      = var.k8s_namespace
}

resource "aws_iam_role" "loki" {
  count                 = local.loki_enabled ? 1 : 0
  name                  = local.loki_iam_role_name
  assume_role_policy    = module.loki_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_permissions" {
  count  = local.loki_enabled ? 1 : 0
  name   = "loki-permissions"
  role   = aws_iam_role.loki[0].id
  policy = data.aws_iam_policy_document.loki_permissions[0].json
}

## end loki role

## loki compactor role

locals {
  loki_compactor_iam_role_name = var.loki_compactor_iam_role_name == "" ? null : var.loki_compactor_iam_role_name
}

module "loki_compactor_assume_role_policy" {
  count                 = local.loki_enabled ? 1 : 0
  source                = "andreswebs/eks-irsa-policy-document/aws"
  version               = "~> 1.0"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_compactor_k8s_sa_name
  k8s_sa_namespace      = var.k8s_namespace
}

resource "aws_iam_role" "loki_compactor" {
  count                 = local.loki_enabled ? 1 : 0
  name                  = local.loki_compactor_iam_role_name
  assume_role_policy    = module.loki_compactor_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_compactor_permissions" {
  count  = local.loki_enabled ? 1 : 0
  name   = "loki-compactor-permissions"
  role   = aws_iam_role.loki_compactor[0].id
  policy = data.aws_iam_policy_document.loki_permissions[0].json
}

## end loki compactor role
