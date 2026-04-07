# A local_file resource — the filename attribute is missing, which will
# cause terraform apply to fail.

resource "local_file" "old_name" {
  content  = "managed by terraform"
  # BUG: filename attribute is missing
}
