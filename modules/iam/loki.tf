locals {
  loki_iam_role_name           = var.loki_iam_role_name == "" ? null : var.loki_iam_role_name
  loki_compactor_iam_role_name = var.loki_compactor_iam_role_name == "" ? null : var.loki_compactor_iam_role_name
  loki_storage_kms_key_arn     = var.loki_storage_kms_key_arn == "" ? null : var.loki_storage_kms_key_arn
  kms_enabled                  = local.loki_storage_kms_key_arn != null
}

data "aws_s3_bucket" "loki_storage" {
  count  = var.loki_enabled ? 1 : 0
  bucket = var.loki_storage_s3_bucket_name
}

## policy documents

data "aws_iam_policy_document" "bucket_crud" {
  count = var.loki_enabled ? 1 : 0

  statement {
    sid = "AllowListObjects"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      data.aws_s3_bucket.loki_storage[0].arn
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
      "${data.aws_s3_bucket.loki_storage[0].arn}/*"
    ]
  }

}

data "aws_iam_policy_document" "kms_permissions" {
  count = var.loki_enabled ? 1 : 0

  dynamic "statement" {
    for_each = toset([local.loki_storage_kms_key_arn])
    content {
      sid = "AllowUseKey"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ]
      resources = [local.loki_storage_kms_key_arn]
    }
  }

}

locals {
  loki_permission_documents = compact([
    (var.loki_enabled ? data.aws_iam_policy_document.bucket_crud[0].json : ""),
    (local.kms_enabled ? data.aws_iam_policy_document.kms_permissions[0].json : "")
  ])
}

data "aws_iam_policy_document" "loki_permissions" {
  count                   = var.loki_enabled ? 1 : 0
  source_policy_documents = local.loki_permission_documents
}

## end policy documents

## loki role

module "loki_assume_role_policy" {
  count                 = var.loki_enabled ? 1 : 0
  source                = "andreswebs/eks-irsa-policy-document/aws"
  version               = "~> 1.0"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_service_account_name
  k8s_sa_namespace      = var.k8s_namespace
}

resource "aws_iam_role" "loki" {
  count                 = var.loki_enabled ? 1 : 0
  name                  = local.loki_iam_role_name
  assume_role_policy    = module.loki_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_permissions" {
  count  = var.loki_enabled ? 1 : 0
  name   = "loki-permissions"
  role   = aws_iam_role.loki[0].id
  policy = data.aws_iam_policy_document.loki_permissions[0].json
}

## end loki role

## loki compactor role

module "loki_compactor_assume_role_policy" {
  count                 = var.loki_enabled ? 1 : 0
  source                = "andreswebs/eks-irsa-policy-document/aws"
  version               = "~> 1.0"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.loki_compactor_service_account_name
  k8s_sa_namespace      = var.k8s_namespace
}

resource "aws_iam_role" "loki_compactor" {
  count                 = var.loki_enabled ? 1 : 0
  name                  = local.loki_compactor_iam_role_name
  assume_role_policy    = module.loki_compactor_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "loki_compactor_permissions" {
  count  = var.loki_enabled ? 1 : 0
  name   = "loki-compactor-permissions"
  role   = aws_iam_role.loki_compactor[0].id
  policy = data.aws_iam_policy_document.loki_permissions[0].json
}

## end loki compactor role
