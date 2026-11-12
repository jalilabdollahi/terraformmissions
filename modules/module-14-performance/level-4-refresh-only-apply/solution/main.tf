# Pellam Moor weather network, gauge 07.

# The rain feed is written by the station's logger, outside Terraform.
data "local_file" "gauge_feed" {
  filename = "${path.module}/feeds/gauge-07.json"
}

resource "local_file" "station_banner" {
  filename = "${path.module}/banner.txt"
  content  = "${var.banner}\n"
}

output "latest_rainfall_mm" {
  value = jsondecode(data.local_file.gauge_feed.content).rainfall_mm
}

output "feed_updated" {
  value = jsondecode(data.local_file.gauge_feed.content).updated
}
