locals {
  a_path = "${path.module}/a.txt"
  b_path = "${path.module}/b.txt"
}

resource "local_file" "a" {
  content  = "file a references ${local.b_path}"
  filename = local.a_path
}

resource "local_file" "b" {
  content  = "file b references ${local.a_path}"
  filename = local.b_path
}
