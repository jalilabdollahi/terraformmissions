# Halcyon - krewes stack (new home of sign-ups and bead strands).

data "terraform_remote_state" "warehouse" {
  backend = "local"
  config = {
    path = "${path.module}/../warehouse/terraform.tfstate"
  }
}

resource "random_uuid" "signup_ns" {}

resource "random_integer" "bead_series" {
  for_each = toset(["gold", "silver"])
  min      = 10000
  max      = 99999
}

resource "local_file" "bead_ledger" {
  filename = "${path.module}/../out/bead-ledger.txt"
  content  = "signup ${random_uuid.signup_ns.result}\ndock ${data.terraform_remote_state.warehouse.outputs.dock_key}\nriders ${data.terraform_remote_state.warehouse.outputs.rider_capacity}\ngold ${random_integer.bead_series["gold"].result} silver ${random_integer.bead_series["silver"].result}\n"
}

output "gold_series" {
  value = random_integer.bead_series["gold"].result
}
