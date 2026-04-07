resource "local_file" "marker" {
  content  = "workspace: ${terraform.workspace}"
  filename = "${path.module}/marker.txt"
}
