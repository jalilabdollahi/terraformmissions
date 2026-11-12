variable "site" {
  type    = string
  default = "brest-landing"
}

variable "landing_password" {
  type      = string
  sensitive = true
}

resource "terraform_data" "handshake" {
  triggers_replace = [var.site]

  provisioner "local-exec" {
    command = "bash ${path.module}/bin/handshake.sh --site ${var.site} --password ${var.landing_password}"
  }
}
