# Blue Note axe-throwing bar: the booking stack takes its settings from a tfvars file.
# Instead of hand-assembling "key = value" lines with join() and format(), the venue
# object is serialised with the provider function encode_tfvars, and last month's
# settings are read back with decode_tfvars to see how much the room grew.

locals {
  night = {
    room    = "Blue Note"
    seats   = 24
    open    = true
    targets = ["Bullseye", "Skull Board"]
    limits  = { per_thrower = 2, minutes = 4 }
  }

  previous = provider::terraform::decode_tfvars(file("${path.module}/stack/previous.tfvars"))
}

resource "local_file" "booking_vars" {
  filename = "${path.module}/stack/night.tfvars"
  content  = provider::terraform::encode_tfvars(local.night)
}

output "seat_growth" {
  value = local.night.seats - local.previous.seats
}
