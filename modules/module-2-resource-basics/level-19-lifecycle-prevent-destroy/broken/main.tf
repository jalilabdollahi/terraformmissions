# BUG: prevent_destroy = true blocks any destroy operation.
# Change it to false to allow the resource to be destroyed.

resource "local_file" "important" {
  content  = "critical data"
  filename = "${path.module}/important.txt"

  lifecycle {
    prevent_destroy = true
  }
}
