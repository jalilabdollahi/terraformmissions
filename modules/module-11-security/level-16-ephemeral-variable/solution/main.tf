variable "loft_name" {
  type    = string
  default = "Fairwind Sail Loft"
}

variable "gateway_token" {
  type      = string
  sensitive = true
  ephemeral = true
}

# Publishes the loft's booking calendar to the gateway whenever the loft name changes.
resource "terraform_data" "publish_calendar" {
  input = {
    loft = var.loft_name
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/bin/publish.sh"

    environment = {
      LOFT_NAME     = self.input.loft
      GATEWAY_TOKEN = var.gateway_token
    }
  }
}

output "published_loft" {
  value = terraform_data.publish_calendar.input.loft
}
