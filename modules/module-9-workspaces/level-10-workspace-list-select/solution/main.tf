variable "workspace_name" {
  type        = string
  description = "The name of the current workspace"
  default     = "default"
}

resource "local_file" "info" {
  content  = "workspace: ${var.workspace_name} / actual: ${terraform.workspace}"
  filename = "${path.module}/workspace-info.txt"
}
