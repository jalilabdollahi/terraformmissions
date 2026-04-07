# Resource B reads the file created by resource A.
# The filename in resource B is hardcoded to "default-data.txt" instead of using
# terraform.workspace, so it only works in the default workspace.
# Fix: change "default-data.txt" to "${terraform.workspace}-data.txt"

resource "local_file" "resource_a" {
  content  = "data from resource A in workspace ${terraform.workspace}"
  filename = "${path.module}/${terraform.workspace}-data.txt"
}

resource "local_file" "resource_b" {
  content    = "resource B referencing: ${path.module}/default-data.txt"
  filename   = "${path.module}/${terraform.workspace}-output.txt"
  depends_on = [local_file.resource_a]
}

output "b_content" {
  value = local_file.resource_b.content
}
