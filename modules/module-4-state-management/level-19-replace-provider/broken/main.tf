# Greenfield Orchard: crate tagging.
# The state was written by Terraform 0.12 and still names the random provider
# with the old unqualified address. The code itself is fine.

resource "random_id" "crate_tag" {
  byte_length = 4
  prefix      = "GF-"
}

resource "random_integer" "pallet_count" {
  min = 20
  max = 48
}

resource "local_file" "crate_label" {
  filename = "${path.module}/labels/crate.txt"
  content  = "Crate ${random_id.crate_tag.hex}, ${random_integer.pallet_count.result} pallets\n"
}
