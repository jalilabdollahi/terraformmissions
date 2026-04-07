resource "local_file" "config" {
  content  = "check this file"
  filename = "${path.module}/config.txt"
}

# Bug: .id on local_file may be empty or unexpected; use .filename for a meaningful check
check "file_exists" {
  assert {
    condition     = local_file.config.id != ""
    error_message = "Config file was not created properly."
  }
}
