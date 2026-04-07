resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

# BUG: depends_on references a resource that doesn't exist.
resource "local_file" "app" {
  content  = "app data"
  filename = "${path.module}/app.txt"

  depends_on = [local_file.nonexistent]
}
