resource "local_file" "resource_a" {
  content  = "Resource A content"
  filename = "${path.module}/resource_a.txt"
}

resource "local_file" "resource_b" {
  content  = "Resource B — depends on A: ${local_file.resource_a.filename}"
  filename = "${path.module}/resource_b.txt"
}

resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.filename}"
  filename = "${path.module}/resource_c.txt"
}
