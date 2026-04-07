variable "env" {
  type        = string
  description = "Deployment environment"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod."
  }
}

resource "local_file" "env_file" {
  content  = "env=${var.env}"
  filename = "${path.module}/env.txt"
}
