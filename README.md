# terraform-aws-eks-monitoring

Deploys the "Grafana + Prometheus + Loki" monitoring stack via Helm on AWS EKS.

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "monitoring" {
  source = "github.com/andreswebs/terraform-aws-eks-monitoring"

  cluster_oidc_provider = var.eks_cluster_oidc_provider

  loki_iam_role_name           = "loki-${var.eks_cluster_id}"
  loki_compactor_iam_role_name = "loki-compactor-${var.eks_cluster_id}"
  grafana_iam_role_name        = "grafana-${var.eks_cluster_id}"

  loki_storage_s3_bucket_name = var.loki_storage_s3_bucket_name

  chart_version_loki_distributed = var.chart_version_loki_distributed
  chart_version_promtail         = var.chart_version_promtail
  chart_version_prometheus       = var.chart_version_prometheus
  chart_version_grafana          = var.chart_version_grafana

  grafana_enabled = true

}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version_fluent_bit"></a> [chart\_version\_fluent\_bit](#input\_chart\_version\_fluent\_bit) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_grafana"></a> [chart\_version\_grafana](#input\_chart\_version\_grafana) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_loki"></a> [chart\_version\_loki](#input\_chart\_version\_loki) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_loki_distributed"></a> [chart\_version\_loki\_distributed](#input\_chart\_version\_loki\_distributed) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_metrics_server"></a> [chart\_version\_metrics\_server](#input\_chart\_version\_metrics\_server) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_prometheus"></a> [chart\_version\_prometheus](#input\_chart\_version\_prometheus) | Chart version | `string` | `null` | no |
| <a name="input_chart_version_promtail"></a> [chart\_version\_promtail](#input\_chart\_version\_promtail) | Chart version | `string` | `null` | no |
| <a name="input_cluster_oidc_provider"></a> [cluster\_oidc\_provider](#input\_cluster\_oidc\_provider) | OpenID Connect (OIDC) Identity Provider associated with the Kubernetes cluster | `string` | `""` | no |
| <a name="input_create_loki_storage"></a> [create\_loki\_storage](#input\_create\_loki\_storage) | Create S3 bucket for Loki storage? | `bool` | `false` | no |
| <a name="input_create_loki_storage_id_suffix"></a> [create\_loki\_storage\_id\_suffix](#input\_create\_loki\_storage\_id\_suffix) | Append a random identifier string suffix to the Loki storage S3 bucket name? | `bool` | `false` | no |
| <a name="input_create_loki_storage_kms_key"></a> [create\_loki\_storage\_kms\_key](#input\_create\_loki\_storage\_kms\_key) | Create KMS key? | `bool` | `true` | no |
| <a name="input_grafana_enabled"></a> [grafana\_enabled](#input\_grafana\_enabled) | Enable Grafana? | `bool` | `true` | no |
| <a name="input_grafana_k8s_sa_name"></a> [grafana\_k8s\_sa\_name](#input\_grafana\_k8s\_sa\_name) | Name of the Kubernetes service account for Grafana | `string` | `"grafana"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Name of the Kubernetes namespace to which resources will be deployed | `string` | `"monitoring"` | no |
| <a name="input_loki_aggregator"></a> [loki\_aggregator](#input\_loki\_aggregator) | Loki aggregator to install, must be either `promtail` or `fluent-bit` | `string` | `"promtail"` | no |
| <a name="input_loki_compactor_k8s_sa_name"></a> [loki\_compactor\_k8s\_sa\_name](#input\_loki\_compactor\_k8s\_sa\_name) | Name of the Kubernetes service account for the Loki compactor | `string` | `"loki-compactor"` | no |
| <a name="input_loki_enabled"></a> [loki\_enabled](#input\_loki\_enabled) | Enable Loki? | `bool` | `true` | no |
| <a name="input_loki_k8s_sa_name"></a> [loki\_k8s\_sa\_name](#input\_loki\_k8s\_sa\_name) | Name of the Kubernetes service account for Loki components | `string` | `"loki"` | no |
| <a name="input_loki_mode"></a> [loki\_mode](#input\_loki\_mode) | Loki mode, must be either `single` or `distributed` | `string` | `"distributed"` | no |
| <a name="input_loki_storage_expiration_days"></a> [loki\_storage\_expiration\_days](#input\_loki\_storage\_expiration\_days) | Number of days to retain objects; `0` means never expire | `number` | `90` | no |
| <a name="input_loki_storage_kms_key_arn"></a> [loki\_storage\_kms\_key\_arn](#input\_loki\_storage\_kms\_key\_arn) | (Optional) ARN of KMS key used to encrypt bucket objects; ignored if `create_kms_key` is set to `true` | `string` | `null` | no |
| <a name="input_loki_storage_kms_key_deletion_window_in_days"></a> [loki\_storage\_kms\_key\_deletion\_window\_in\_days](#input\_loki\_storage\_kms\_key\_deletion\_window\_in\_days) | KMS key deletion window in days | `number` | `30` | no |
| <a name="input_loki_storage_kms_key_enable_rotation"></a> [loki\_storage\_kms\_key\_enable\_rotation](#input\_loki\_storage\_kms\_key\_enable\_rotation) | Enable KMS key rotation? | `bool` | `true` | no |
| <a name="input_loki_storage_s3_bucket_name"></a> [loki\_storage\_s3\_bucket\_name](#input\_loki\_storage\_s3\_bucket\_name) | Name of S3 bucket used for Loki storage | `string` | `""` | no |
| <a name="input_loki_storage_s3_force_destroy"></a> [loki\_storage\_s3\_force\_destroy](#input\_loki\_storage\_s3\_force\_destroy) | Force destroy bucket when running `terraform destroy`? | `bool` | `true` | no |
| <a name="input_metrics_server_enabled"></a> [metrics\_server\_enabled](#input\_metrics\_server\_enabled) | Enable Metrics Server? | `bool` | `true` | no |
| <a name="input_prometheus_enabled"></a> [prometheus\_enabled](#input\_prometheus\_enabled) | Enable Prometheus? | `bool` | `true` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_log_storage"></a> [log\_storage](#module\_log\_storage) | ./modules/storage | n/a |
| <a name="module_resources"></a> [resources](#module\_resources) | ./modules/resources | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The name (`metadata.name`) of the namespace |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.48.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

[//]: # (END_TF_DOCS)

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
