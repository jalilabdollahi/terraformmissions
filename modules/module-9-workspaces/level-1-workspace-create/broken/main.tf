# Typo: "workpsace" should be "workspace"
# Fix: change terraform.workpsace to terraform.workspace

resource "local_file" "env_marker" {
  content  = "environment: ${terraform.workspace}"
  filename = "${path.module}/${terraform.workpsace}.txt"
}
