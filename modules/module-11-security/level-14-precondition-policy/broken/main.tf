variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "policy" {
  content  = "environment=${var.env}"
  filename = "${path.module}/policy.conf"

  lifecycle {
    precondition {
      # Broken: this blocks production deployments
      condition     = var.env != "production"
      error_message = "Unsupported environment. Use dev, staging, or production."
    }
  }
}
