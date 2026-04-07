resource "local_file" "config" {
  content  = "plan test"
  filename = "${path.module}/config.txt"
}

resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.config.id
  }
}
