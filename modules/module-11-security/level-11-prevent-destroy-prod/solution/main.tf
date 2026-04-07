resource "local_file" "db_config" {
  content  = "DATABASE_URL=postgres://prod-db:5432/app"
  filename = "${path.module}/db.conf"

  lifecycle {
    prevent_destroy = terraform.workspace == "production"
  }
}
