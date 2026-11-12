# Halcyon - lighting stack (new home of the lighting-rig key, controllers and cue sheet).

data "terraform_remote_state" "warehouse" {
  backend = "local"
  config = {
    path = "${path.module}/../warehouse/terraform.tfstate"
  }
}

data "terraform_remote_state" "krewes" {
  backend = "local"
  config = {
    path = "${path.module}/../krewes/terraform.tfstate"
  }
}

resource "random_id" "light_key" {
  byte_length = 6
}

resource "terraform_data" "controller" {
  for_each = toset(["a", "b"])
  input    = "controller-${each.key}"
}

resource "local_file" "cue_sheet" {
  filename = "${path.module}/../out/cue_sheet.txt"
  content  = "lights ${random_id.light_key.hex} dock ${data.terraform_remote_state.warehouse.outputs.dock_key} gold ${data.terraform_remote_state.krewes.outputs.gold_series}\n"
}
