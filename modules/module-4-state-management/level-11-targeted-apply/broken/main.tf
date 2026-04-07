# Three chained resources: A -> B -> C
# BUG: resource C references a nonexistent attribute "content_md5" from B

resource "local_file" "resource_a" {
  content  = "Resource A content"
  filename = "${path.module}/resource_a.txt"
}

resource "local_file" "resource_b" {
  content  = "Resource B — depends on A: ${local_file.resource_a.filename}"
  filename = "${path.module}/resource_b.txt"
}

# BUG: local_file has no exported attribute "content_md5"; use "filename"
resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.content_md5}"
  filename = "${path.module}/resource_c.txt"
}
