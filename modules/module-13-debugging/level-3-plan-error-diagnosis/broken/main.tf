resource "local_file" "config" {
  content  = "plan test"
  filename = "${path.module}/config.txt"
}

# Bug: trigger references local_file.nonexistent which doesn't exist
resource "null_resource" "watcher" {
  triggers = {
    config_id = local_file.nonexistent.id
  }
}
