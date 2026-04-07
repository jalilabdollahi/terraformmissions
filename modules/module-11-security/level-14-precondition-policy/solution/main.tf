variable "env" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.env)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

resource "local_file" "policy" {
  content  = "environment=${var.env}"
  filename = "${path.module}/policy.conf"

  lifecycle {
    precondition {
      condition     = contains(["dev", "staging", "production"], var.env)
      error_message = "Unsupported environment. Use dev, staging, or production."
    }
  }
}
