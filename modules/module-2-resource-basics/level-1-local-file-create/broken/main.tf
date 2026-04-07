# The filename points to a path whose parent directories don't exist.
# Terraform's local_file provider will not create intermediate directories.

resource "local_file" "config" {
  content  = "environment = production"
  filename = "/tmp/nonexistent/dir/config.txt"
}
