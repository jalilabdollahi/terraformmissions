resource "local_file" "config" {
  content  = "check this file"
  filename = "${path.module}/config.txt"
}

check "file_exists" {
  assert {
    condition     = local_file.config.filename != ""
    error_message = "Config file was not created properly."
  }
}
