resource "local_file" "env_marker" {
  content  = "environment: ${terraform.workspace}"
  filename = "${path.module}/${terraform.workspace}.txt"
}
