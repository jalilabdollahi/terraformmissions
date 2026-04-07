# Complex scenario: 3 resources, one has wrong resource type.
# BUG: "local_files" does not exist — should be "local_file"
# BUG: output also references the wrong type

resource "local_file" "config_a" {
  content  = "config a"
  filename = "${path.module}/config_a.txt"
}

resource "local_files" "config_b" {
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
    local_files.config_b.filename,
    local_file.config_c.filename,
  ]
}
