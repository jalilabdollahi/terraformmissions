# Karst Peak Mountain Rescue — dispatch radio plan.
# Naming cleanup (callsign -> id) was merged layer by layer by three different people:
#   root, region and post modules each renamed their own variable.
# The beacon serial and repeater channel are programmed into field radios; they must not change.

module "region" {
  source = "./modules/region"

  base_callsign = var.station_callsign
}

resource "local_file" "dispatch_log" {
  filename = "${path.module}/plan/dispatch.txt"
  content  = "station ${var.dispatch_id} channel ${module.region.channel} beacon ${module.region.beacon_serial}\n"
}

output "channel" {
  value = module.region.channel
}

output "beacon_serial" {
  value = module.region.beacon_serial
}
