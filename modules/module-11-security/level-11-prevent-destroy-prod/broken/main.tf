resource "local_file" "db_config" {
  content  = "DATABASE_URL=postgres://prod-db:5432/app"
  filename = "${path.module}/db.conf"

  lifecycle {
    # Broken: hardcoded true blocks destruction in ALL workspaces, including dev
    prevent_destroy = true
  }
}
