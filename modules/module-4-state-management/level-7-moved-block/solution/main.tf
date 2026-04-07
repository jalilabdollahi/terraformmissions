moved {
  from = local_file.old_name
  to   = local_file.new_name
}

resource "local_file" "new_name" {
  content  = "managed file content"
  filename = "${path.module}/managed.txt"
}
