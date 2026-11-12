# Lighthouse keeper roster.
# A teammate renamed `random_pet.keeper` to `random_pet.night_keeper` for clarity.
# The rename is correct — but `terraform plan` now wants to destroy the current
# keeper's codename and invent a new one. The codename is printed on badges;
# it must NOT change.

resource "random_pet" "night_keeper" {
  length    = 2
  separator = "-"
  prefix    = "lamp"
}

resource "local_file" "roster" {
  filename = "${path.module}/roster/night-shift.txt"
  content  = "On duty tonight: ${random_pet.night_keeper.id}\n"
}

output "keeper_codename" {
  value = random_pet.night_keeper.id
}
