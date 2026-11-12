# Cave survey: three small probe scripts report the chamber conditions for the base-camp board.

data "external" "bore" {
  program = ["bash", "${path.module}/scripts/bore-depth.sh"]
}

data "external" "air" {
  program = ["${path.module}/probes/air-quality.py"]
}

data "external" "damp" {
  program = ["python3", "${path.module}/probes/humidity.sh"]
}

locals {
  depth_m  = tonumber(data.external.bore.result.depth_m)
  o2_pct   = tonumber(data.external.air.result.o2_pct)
  humidity = tonumber(data.external.damp.result.humidity_pct)
  safe_air = local.o2_pct >= 19.5
}

resource "local_file" "board" {
  filename = "${path.module}/camp/board.txt"
  content  = <<-EOT
    Chamber depth: ${local.depth_m} m
    Oxygen: ${local.o2_pct}% (${local.safe_air ? "breathable" : "NO ENTRY"})
    Humidity: ${local.humidity}%
  EOT
}

output "depth_m" {
  value = local.depth_m
}

output "o2_pct" {
  value = local.o2_pct
}

output "humidity_pct" {
  value = local.humidity
}
