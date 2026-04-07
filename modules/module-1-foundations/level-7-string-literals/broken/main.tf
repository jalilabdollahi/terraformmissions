resource "local_file" "config" {
  content  = "database_url=postgres://localhost:5432/app   # Missing closing quote
  filename = "${path.module}/config.env"
}
