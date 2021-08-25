# terraform-aws-eks-monitoring storage

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "log_storage" {
  source           = "github.com/andreswebs/terraform-aws-eks-monitoring//modules/storage"
  s3_bucket_name   = var.loki_storage_s3_bucket_name
  s3_force_destroy = true
  create_kms_key   = true
  kms_key_alias    = "alias/${var.loki_storage_s3_bucket_name}"
  expiration_days  = 365
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create KMS key? | `bool` | `true` | no |
| <a name="input_create_s3_bucket_id_suffix"></a> [create\_s3\_bucket\_id\_suffix](#input\_create\_s3\_bucket\_id\_suffix) | Append a random identifier string suffix to the Loki storage S3 bucket name? | `bool` | `false` | no |
| <a name="input_expiration_days"></a> [expiration\_days](#input\_expiration\_days) | Number of days to retain objects; `0` means never expire | `number` | `0` | no |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | (Optional) An alias for the generated KMS key; must start with `alias/` | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Optional) ARN of KMS key used to encrypt bucket objects; ignored if `create_kms_key` is set to `true` | `string` | `null` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | KMS key deletion window in days | `number` | `30` | no |
| <a name="input_kms_key_enable_rotation"></a> [kms\_key\_enable\_rotation](#input\_kms\_key\_enable\_rotation) | Enable KMS key rotation? | `bool` | `true` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of S3 bucket created for Loki storage | `string` | `""` | no |
| <a name="input_s3_force_destroy"></a> [s3\_force\_destroy](#input\_s3\_force\_destroy) | Force destroy bucket when running `terraform destroy`? | `bool` | `false` | no |

## Modules

No modules.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | S3 bucket |
| <a name="output_encryption_key"></a> [encryption\_key](#output\_encryption\_key) | KMS key used for encryption, if created |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Requirements

No requirements.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

[//]: # (END_TF_DOCS)
