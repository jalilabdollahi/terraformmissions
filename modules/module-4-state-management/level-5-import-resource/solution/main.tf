resource "local_file" "existing" {
  content  = "pre-existing file content"
  filename = "/tmp/tm_existing.txt"
}
