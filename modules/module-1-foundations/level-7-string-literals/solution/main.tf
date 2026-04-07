resource "local_file" "config" {
  content  = "database_url=postgres://localhost:5432/app"
  filename = "${path.module}/config.env"
}
