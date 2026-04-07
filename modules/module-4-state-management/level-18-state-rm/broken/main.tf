# BUG: wrong resource type — "local_files" doesn't exist; should be "local_file"

resource "local_files" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
