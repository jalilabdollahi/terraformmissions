module "region" {
  source        = "./modules/region"
  base_callsign = var.station_callsign
}
resource "local_file" "dispatch_log" {
  filename = "${path.module}/plan/dispatch.txt"
  content  = "station ${var.station_callsign} channel ${module.region.channel} beacon ${module.region.beacon_serial}\n"
}
output "channel" {
  value = module.region.channel
}
output "beacon_serial" {
  value = module.region.beacon_serial
}
