resource "local_file" "greeting" {
  content  = "hello world"
  filename = "${path.module}/greeting.txt"
}

# Missing: no output block — the parent cannot access the filename.
