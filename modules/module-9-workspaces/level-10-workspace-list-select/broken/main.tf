# var.workspace_name has no default, so terraform plan prompts for input.
# Fix: add default = "default" to the variable.

variable "workspace_name" {
  type        = string
  description = "The name of the current workspace"
}

resource "local_file" "info" {
  content  = "workspace: ${var.workspace_name} / actual: ${terraform.workspace}"
  filename = "${path.module}/workspace-info.txt"
}
