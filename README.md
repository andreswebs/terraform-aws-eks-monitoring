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
| <a name="input_grafana_iam_role_name"></a> [grafana\_iam\_role\_name](#input\_grafana\_iam\_role\_name) | Name of IAM role for Grafana | `string` | `"grafana"` | no |
| <a name="input_grafana_service_account_name"></a> [grafana\_service\_account\_name](#input\_grafana\_service\_account\_name) | Name of the Kubernetes service account for Grafana | `string` | `"grafana"` | no |
| <a name="input_helm_atomic_creation"></a> [helm\_atomic\_creation](#input\_helm\_atomic\_creation) | Purge resources on installation failure ? The wait flag will be set automatically if atomic is used | `bool` | `true` | no |
| <a name="input_helm_cleanup_on_fail"></a> [helm\_cleanup\_on\_fail](#input\_helm\_cleanup\_on\_fail) | Deletion new resources created in this upgrade if the upgrade fails ? | `bool` | `true` | no |
| <a name="input_helm_create_namespace"></a> [helm\_create\_namespace](#input\_helm\_create\_namespace) | Create the namespace if it does not yet exist ? | `bool` | `true` | no |
| <a name="input_helm_dependency_update"></a> [helm\_dependency\_update](#input\_helm\_dependency\_update) | Run helm dependency update before installing the chart ? | `bool` | `false` | no |
| <a name="input_helm_force_update"></a> [helm\_force\_update](#input\_helm\_force\_update) | Force resource update through delete/recreate if needed ? | `bool` | `false` | no |
| <a name="input_helm_keyring"></a> [helm\_keyring](#input\_helm\_keyring) | Location of public keys used for verification; used only if verify is true | `string` | `".gnupg/pubring.gpg"` | no |
| <a name="input_helm_max_history"></a> [helm\_max\_history](#input\_helm\_max\_history) | Maximum number of release versions stored per release; `0` means no limit | `number` | `3` | no |
| <a name="input_helm_recreate_pods"></a> [helm\_recreate\_pods](#input\_helm\_recreate\_pods) | Perform pods restart during upgrade/rollback ? | `bool` | `true` | no |
| <a name="input_helm_release_name_fluent_bit"></a> [helm\_release\_name\_fluent\_bit](#input\_helm\_release\_name\_fluent\_bit) | Release name | `string` | `"fluent-bit"` | no |
| <a name="input_helm_release_name_grafana"></a> [helm\_release\_name\_grafana](#input\_helm\_release\_name\_grafana) | Release name | `string` | `"grafana"` | no |
| <a name="input_helm_release_name_loki"></a> [helm\_release\_name\_loki](#input\_helm\_release\_name\_loki) | Release name | `string` | `"loki"` | no |
| <a name="input_helm_release_name_metrics_server"></a> [helm\_release\_name\_metrics\_server](#input\_helm\_release\_name\_metrics\_server) | Release name | `string` | `"metrics-server"` | no |
| <a name="input_helm_release_name_prometheus"></a> [helm\_release\_name\_prometheus](#input\_helm\_release\_name\_prometheus) | Release name | `string` | `"prometheus"` | no |
| <a name="input_helm_release_name_promtail"></a> [helm\_release\_name\_promtail](#input\_helm\_release\_name\_promtail) | Release name | `string` | `"promtail"` | no |
| <a name="input_helm_replace"></a> [helm\_replace](#input\_helm\_replace) | Re-use the given name, even if that name is already used; this is unsafe in production | `bool` | `false` | no |
| <a name="input_helm_reset_values"></a> [helm\_reset\_values](#input\_helm\_reset\_values) | When upgrading, reset the values to the ones built into the chart ? | `bool` | `false` | no |
| <a name="input_helm_reuse_values"></a> [helm\_reuse\_values](#input\_helm\_reuse\_values) | When upgrading, reuse the last release's values and merge any overrides ? If 'reset\_values' is specified, this is ignored | `bool` | `false` | no |
| <a name="input_helm_skip_crds"></a> [helm\_skip\_crds](#input\_helm\_skip\_crds) | Skip installing CRDs ? | `bool` | `false` | no |
| <a name="input_helm_timeout_seconds"></a> [helm\_timeout\_seconds](#input\_helm\_timeout\_seconds) | Time in seconds to wait for any individual kubernetes operation | `number` | `300` | no |
| <a name="input_helm_verify"></a> [helm\_verify](#input\_helm\_verify) | Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart | `bool` | `false` | no |
| <a name="input_helm_wait_for_completion"></a> [helm\_wait\_for\_completion](#input\_helm\_wait\_for\_completion) | Wait until all resources are in a ready state before marking the release as successful ? | `bool` | `true` | no |
| <a name="input_helm_wait_for_jobs"></a> [helm\_wait\_for\_jobs](#input\_helm\_wait\_for\_jobs) | Wait until all Jobs have been completed before marking the release as successful ? | `bool` | `true` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Name of the Kubernetes namespace to which resources will be deployed | `string` | `"monitoring"` | no |
| <a name="input_loki_aggregator"></a> [loki\_aggregator](#input\_loki\_aggregator) | Loki aggregator to install, must be either `promtail` or `fluent-bit` | `string` | `"promtail"` | no |
| <a name="input_loki_compactor_iam_role_name"></a> [loki\_compactor\_iam\_role\_name](#input\_loki\_compactor\_iam\_role\_name) | Name of IAM role for Loki Compactor | `string` | `"loki-compactor"` | no |
| <a name="input_loki_compactor_service_account_name"></a> [loki\_compactor\_service\_account\_name](#input\_loki\_compactor\_service\_account\_name) | Name of the Kubernetes service account for the Loki compactor | `string` | `"loki-compactor"` | no |
| <a name="input_loki_enabled"></a> [loki\_enabled](#input\_loki\_enabled) | Enable Loki? | `bool` | `true` | no |
| <a name="input_loki_iam_role_name"></a> [loki\_iam\_role\_name](#input\_loki\_iam\_role\_name) | Name of IAM role for Loki | `string` | `"loki"` | no |
| <a name="input_loki_mode"></a> [loki\_mode](#input\_loki\_mode) | Loki mode, must be either `single` or `distributed` | `string` | `"distributed"` | no |
| <a name="input_loki_service_account_name"></a> [loki\_service\_account\_name](#input\_loki\_service\_account\_name) | Name of the Kubernetes service account for Loki components | `string` | `"loki"` | no |
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
