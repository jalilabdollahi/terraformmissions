# Halcyon Mardi Gras Float Warehouse - the original single stack (to be split, see ../SPLIT-PLAN.md).

# --- warehouse ---
resource "random_id" "dock_key" {
  byte_length = 4
}

resource "random_integer" "rider_capacity" {
  min = 180
  max = 640
}

resource "random_id" "float_serial" {
  for_each    = toset(["main", "annex"])
  byte_length = 3
}

# --- krewes ---
resource "random_uuid" "signup_ns" {}

resource "random_integer" "bead_series" {
  for_each = toset(["gold", "silver"])
  min      = 10000
  max      = 99999
}

resource "local_file" "bead_ledger" {
  filename = "${path.module}/../out/bead-ledger.txt"
  content  = "signup ${random_uuid.signup_ns.result}\ndock ${random_id.dock_key.hex}\nriders ${random_integer.rider_capacity.result}\ngold ${random_integer.bead_series["gold"].result} silver ${random_integer.bead_series["silver"].result}\n"
}

# --- lighting ---
resource "random_id" "rig_key" {
  byte_length = 6
}

resource "terraform_data" "controller" {
  for_each = toset(["a", "b"])
  input    = "controller-${each.key}"
}

resource "local_file" "cue_sheet" {
  filename = "${path.module}/../out/cue_sheet.txt"
  content  = "lights ${random_id.rig_key.hex} dock ${random_id.dock_key.hex} gold ${random_integer.bead_series["gold"].result}\n"
}
