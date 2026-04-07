# A resource protected by prevent_destroy = true
# BUG: prevent_destroy blocks the destroy plan

resource "local_file" "protected" {
  content  = "this file is protected"
  filename = "${path.module}/protected.txt"

  lifecycle {
    prevent_destroy = true
  }
}
