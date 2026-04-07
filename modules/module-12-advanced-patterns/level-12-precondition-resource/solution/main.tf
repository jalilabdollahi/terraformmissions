variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "config" {
  content  = "env=${var.env}"
  filename = "${path.module}/config.txt"

  lifecycle {
    precondition {
      condition     = contains(["dev", "staging", "production"], var.env)
      error_message = "Environment must be one of: dev, staging, production."
    }
  }
}
