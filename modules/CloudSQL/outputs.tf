output "db_user_password" {
  value = module.sql-db_mysql.generated_user_password
}

output "instance_ip_address" {
  value = module.sql-db_mysql.instance_ip_address
}
