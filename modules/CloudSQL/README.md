# CloudSQL module for CloudMC

This module is used to deploy a CloudSQL instance, bucket for backups and scheduled
functions for automated backup jobs (hourly and weekly) for CloudMC.

## Generating docs

You can generate docs using `terraform-docs.io`. To update the README.md, you can run the following command:

```
terraform-docs markdown table . > README.md
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.53 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.48 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.53 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | terraform-google-modules/cloud-storage/google//modules/simple_bucket | ~> 1.3 |
| <a name="module_scheduled-function"></a> [scheduled-function](#module\_scheduled-function) | terraform-google-modules/scheduled-function/google | 1.5.1 |
| <a name="module_sql-db_mysql"></a> [sql-db\_mysql](#module\_sql-db\_mysql) | GoogleCloudPlatform/sql-db/google//modules/mysql | 4.3.0 |

## Resources

| Name | Type |
|------|------|
| [google_app_engine_application.app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_application) | resource |
| [google_compute_network_peering_routes_config.peering_cloudsql_routes1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering_routes_config) | resource |
| [google_compute_network_peering_routes_config.peering_cloudsql_routes2](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering_routes_config) | resource |
| [local_file.hourly_main](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.hourly_requirements](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.weekly_main](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.weekly_requirements](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.bucket](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | List of additional users to grant access to | `list` | `[]` | no |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | n/a | `list` | <pre>[<br>  {<br>    "name": "GKE subnet",<br>    "value": "0.0.0.0/0"<br>  }<br>]</pre> | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | GCS bucket storage class to use | `string` | `"STANDARD"` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | n/a | `list` | <pre>[<br>  {<br>    "name": "default_time_zone",<br>    "value": "+00:00"<br>  },<br>  {<br>    "name": "sql_mode",<br>    "value": "NO_ENGINE_SUBSTITUTION"<br>  },<br>  {<br>    "name": "explicit_defaults_for_timestamp",<br>    "value": "off"<br>  }<br>]</pre> | no |
| <a name="input_databases"></a> [databases](#input\_databases) | n/a | `list` | <pre>[<br>  {<br>    "charset": "utf8",<br>    "collation": "utf8_general_ci",<br>    "name": "cloudmc"<br>  },<br>  {<br>    "charset": "utf8",<br>    "collation": "utf8_general_ci",<br>    "name": "cloudmc_audit"<br>  },<br>  {<br>    "charset": "utf8",<br>    "collation": "utf8_general_ci",<br>    "name": "cloudmc_content"<br>  }<br>]</pre> | no |
| <a name="input_db_user"></a> [db\_user](#input\_db\_user) | n/a | `string` | `"cloudmc"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment deploying to e.g. dev\|staging\|production | `string` | `"dev"` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | n/a | `number` | `30` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | n/a | `string` | `"cloudmc-mysql-dev"` | no |
| <a name="input_instance_tier"></a> [instance\_tier](#input\_instance\_tier) | n/a | `string` | `"db-n1-standard-2"` | no |
| <a name="input_maintenance_day"></a> [maintenance\_day](#input\_maintenance\_day) | n/a | `number` | `7` | no |
| <a name="input_maintenance_hour"></a> [maintenance\_hour](#input\_maintenance\_hour) | n/a | `number` | `8` | no |
| <a name="input_mysql_private_network"></a> [mysql\_private\_network](#input\_mysql\_private\_network) | VPC to deploy the MySQL to | `string` | n/a | yes |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | MySQL version to deploy | `string` | `"MYSQL_8_0"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `"cloudmc-saas-dev"` | no |
| <a name="input_region_id"></a> [region\_id](#input\_region\_id) | n/a | `string` | `"us-central1"` | no |
| <a name="input_user_host_cidr"></a> [user\_host\_cidr](#input\_user\_host\_cidr) | n/a | `string` | `"cloudsqlproxy~10.90.%.%"` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | n/a | `string` | `"cloudmc-saas-vpc-1"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | n/a | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_user_password"></a> [db\_user\_password](#output\_db\_user\_password) | n/a |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | n/a |
