data "local_file" "anemometer" {
  filename = "${path.module}/sensor/wind-knots.txt"
}

locals {
  knots = tonumber(trimspace(data.local_file.anemometer.content))
}

output "wind_knots" {
  value = local.knots
}

output "flight_status" {
  value = local.knots < 18 ? "fly" : "ground"
}
