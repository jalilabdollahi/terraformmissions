resource "local_file" "config" {
  content  = "database_url=postgres://localhost/mydb"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
