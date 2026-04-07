variable "env" {
  type        = string
  description = "Deployment environment"
  validation {
    # This condition only allows the string "valid" — too restrictive!
    condition     = var.env == "valid"
    error_message = "env must be one of: dev, staging, prod."
  }
}

resource "local_file" "env_file" {
  content  = "env=${var.env}"
  filename = "${path.module}/env.txt"
}
