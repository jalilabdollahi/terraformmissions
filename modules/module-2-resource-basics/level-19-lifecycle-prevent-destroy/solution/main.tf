resource "local_file" "important" {
  content  = "critical data"
  filename = "${path.module}/important.txt"

  lifecycle {
    prevent_destroy = false
  }
}
