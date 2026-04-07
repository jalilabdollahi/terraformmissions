variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "config" {
  content  = "env=${var.env}"
  filename = "${path.module}/config.txt"

  # Bug: condition is too strict — only allows "production", rejecting "dev" and "staging"
  lifecycle {
    precondition {
      condition     = var.env == "production"
      error_message = "Environment must be valid."
    }
  }
}
