variable "track_name" {
  type    = string
  default = "Redline Kart Track"
}

variable "gateway_token" {
  type      = string
  sensitive = true
  ephemeral = true
}

# Publishes the track's booking calendar to the gateway whenever the track name changes.
resource "terraform_data" "publish_calendar" {
  input = {
    track = var.track_name
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/bin/publish.sh"

    environment = {
      TRACK_NAME     = self.input.track
      GATEWAY_TOKEN = var.gateway_token
    }
  }
}

output "published_track" {
  value = terraform_data.publish_calendar.input.track
}
