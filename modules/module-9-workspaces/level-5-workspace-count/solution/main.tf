resource "local_file" "optional" {
  count    = terraform.workspace == "default" ? 1 : 0
  content  = "only in default workspace"
  filename = "${path.module}/default-only.txt"
}
