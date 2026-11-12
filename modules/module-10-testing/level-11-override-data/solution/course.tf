data "local_file" "windmeter" {
  filename = "${path.module}/sensor/wind-kph.txt"
}

locals {
  kph = tonumber(trimspace(data.local_file.windmeter.content))
}

output "wind_kph" {
  value = local.kph
}

output "play_status" {
  value = local.kph < 18 ? "open" : "closed"
}
