resource "local_file" "protected" {
  content  = "this file is protected"
  filename = "${path.module}/protected.txt"

  lifecycle {
    prevent_destroy = false
  }
}
