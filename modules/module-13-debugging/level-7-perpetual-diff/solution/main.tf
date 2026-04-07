resource "local_file" "log_marker" {
  content  = "Generated at: deployment"
  filename = "${path.module}/marker.txt"

  lifecycle {
    ignore_changes = [content]
  }
}
