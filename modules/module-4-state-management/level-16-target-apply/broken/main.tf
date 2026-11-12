# Port Meridian: dispatch board.
# Tonight only the route chart can go out. The cargo manifest waits for the
# customs stamp (pending/customs-stamp.txt), which has not arrived.

resource "random_id" "route_code" {
  byte_length = 3
  prefix      = "RT-"
}

resource "local_file" "route_chart" {
  filename = "${path.module}/out/route-chart.txt"
  content  = "Inbound route ${random_id.route_code.hex}: channel 3, draught limit 9 m\n"
}

resource "random_pet" "pilot" {
  length = 1
  prefix = "pilot"
}

resource "local_file" "cargo_manifest" {
  filename = "${path.module}/out/cargo-manifest.txt"
  content  = "Manifest for route ${random_id.route_code.hex}, cleared by customs\n"

  lifecycle {
    precondition {
      condition     = fileexists("${path.module}/pending/customs-stamp.txt")
      error_message = "Customs stamp missing: pending/customs-stamp.txt has not been delivered."
    }
  }
}
