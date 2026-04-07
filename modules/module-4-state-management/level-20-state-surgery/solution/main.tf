resource "local_file" "config_a" {
  content  = "config a"
  filename = "${path.module}/config_a.txt"
}

resource "local_file" "config_b" {
  content  = "config b"
  filename = "${path.module}/config_b.txt"
}

resource "local_file" "config_c" {
  content  = "config c"
  filename = "${path.module}/config_c.txt"
}

output "all_files" {
  value = [
    local_file.config_a.filename,
    local_file.config_b.filename,
    local_file.config_c.filename,
  ]
}
