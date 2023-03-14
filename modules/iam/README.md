# terraform-aws-eks-monitoring iam

Deploys IAM resources.

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "monitoring_iam" {
  source = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/iam"

  cluster_oidc_provider = var.eks_cluster_oidc_provider

  loki_iam_role_name           = "loki-${var.eks_cluster_id}"
  loki_compactor_iam_role_name = "loki-compactor-${var.eks_cluster_id}"
  grafana_iam_role_name        = "grafana-${var.eks_cluster_id}"

  loki_storage_s3_bucket_name = var.loki_storage_s3_bucket_name
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_oidc_provider"></a> [cluster\_oidc\_provider](#input\_cluster\_oidc\_provider) | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | Enable Grafana? | `bool` | `true` | no |
| <a name="input_grafana_iam_role_name"></a> [grafana\_iam\_role\_name](#input\_grafana\_iam\_role\_name) | Name of IAM role for Grafana | `string` | `"grafana"` | no |
| <a name="input_grafana_service_account_name"></a> [grafana\_service\_account\_name](#input\_grafana\_service\_account\_name) | Name of the Kubernetes service account for Grafana | `string` | `"grafana"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Name of the Kubernetes namespace to which resources will be deployed | `string` | `"monitoring"` | no |
| <a name="input_loki_compactor_iam_role_name"></a> [loki\_compactor\_iam\_role\_name](#input\_loki\_compactor\_iam\_role\_name) | Name of IAM role for Loki Compactor | `string` | `"loki-compactor"` | no |
| <a name="input_loki_compactor_service_account_name"></a> [loki\_compactor\_service\_account\_name](#input\_loki\_compactor\_service\_account\_name) | Name of the Kubernetes service account for the Loki compactor | `string` | `"loki-compactor"` | no |
| <a name="input_loki_enabled"></a> [loki\_enabled](#input\_loki\_enabled) | Enable Loki? | `bool` | `true` | no |
| <a name="input_loki_iam_role_name"></a> [loki\_iam\_role\_name](#input\_loki\_iam\_role\_name) | Name of IAM role for Loki | `string` | `"loki"` | no |
| <a name="input_loki_service_account_name"></a> [loki\_service\_account\_name](#input\_loki\_service\_account\_name) | Name of the Kubernetes service account for Loki components | `string` | `"loki"` | no |
| <a name="input_loki_storage_kms_key_arn"></a> [loki\_storage\_kms\_key\_arn](#input\_loki\_storage\_kms\_key\_arn) | (Optional) ARN of the KMS key used for S3 encryption | `string` | `""` | no |
| <a name="input_loki_storage_s3_bucket_name"></a> [loki\_storage\_s3\_bucket\_name](#input\_loki\_storage\_s3\_bucket\_name) | Name of the S3 bucket used for Loki storage | `string` | `""` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_assume_role_policy"></a> [grafana\_assume\_role\_policy](#module\_grafana\_assume\_role\_policy) | andreswebs/eks-irsa-policy-document/aws | ~> 1.0 |
| <a name="module_loki_assume_role_policy"></a> [loki\_assume\_role\_policy](#module\_loki\_assume\_role\_policy) | andreswebs/eks-irsa-policy-document/aws | ~> 1.0 |
| <a name="module_loki_compactor_assume_role_policy"></a> [loki\_compactor\_assume\_role\_policy](#module\_loki\_compactor\_assume\_role\_policy) | andreswebs/eks-irsa-policy-document/aws | ~> 1.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role"></a> [role](#output\_role) | IAM roles |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.50 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.loki_compactor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.grafana_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.loki_compactor_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.loki_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.bucket_crud](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.loki_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

[//]: # (END_TF_DOCS)
