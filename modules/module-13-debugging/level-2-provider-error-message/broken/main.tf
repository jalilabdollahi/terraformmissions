resource "local_file" "config" {
  content  = "permission test"
  filename = "${path.module}/config.txt"

  # Bug: file_permission must be a string, not a number
  file_permission = 644
}
