# North annex: three decommissioned berths, scheduled for retirement.

resource "random_pet" "berth_tag" {
  length    = 2
  separator = "-"
  prefix    = "annex"
}

resource "random_integer" "crane_slot" {
  min = 10
  max = 99
}

resource "local_file" "berth_sheet" {
  filename = "${path.root}/registry/annex-berths.txt"
  content  = "${var.yard_name} annex ${random_pet.berth_tag.id} crane ${random_integer.crane_slot.result}\n"
}

output "berth_tag" {
  value = random_pet.berth_tag.id
}

output "crane_slot" {
  value = random_integer.crane_slot.result
}
