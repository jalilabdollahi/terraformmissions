resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

resource "local_file" "app" {
  content  = "app data"
  filename = "${path.module}/app.txt"

  depends_on = [local_file.config]
}
