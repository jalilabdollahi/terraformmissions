# Meridian Haulage: dispatch board.
# Tonight only the route chart can go out. The load manifest waits for the
# weighbridge ticket (pending/weighbridge-ticket.txt), which has not arrived.

resource "random_id" "route_code" {
  byte_length = 3
  prefix      = "RT-"
}

resource "local_file" "route_chart" {
  filename = "${path.module}/out/route-chart.txt"
  content  = "Inbound route ${random_id.route_code.hex}: motorway M3, height limit 4 m\n"
}

resource "random_pet" "driver" {
  length = 1
  prefix = "driver"
}

resource "local_file" "load_manifest" {
  filename = "${path.module}/out/load-manifest.txt"
  content  = "Manifest for route ${random_id.route_code.hex}, cleared at the weighbridge\n"

  lifecycle {
    precondition {
      condition     = fileexists("${path.module}/pending/weighbridge-ticket.txt")
      error_message = "Weighbridge ticket missing: pending/weighbridge-ticket.txt has not been delivered."
    }
  }
}
