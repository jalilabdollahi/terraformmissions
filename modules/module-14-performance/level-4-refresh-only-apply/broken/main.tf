# Whistling Basin Geyser Park, geyser 07.

# The eruption feed is written by the vent's logger, outside Terraform.
data "local_file" "geyser_feed" {
  filename = "${path.module}/feeds/geyser-07.json"
}

resource "local_file" "park_banner" {
  filename = "${path.module}/banner.txt"
  content  = "${var.banner}\n"
}

output "latest_height_m" {
  value = jsondecode(data.local_file.geyser_feed.content).height_m
}

output "feed_updated" {
  value = jsondecode(data.local_file.geyser_feed.content).updated
}
