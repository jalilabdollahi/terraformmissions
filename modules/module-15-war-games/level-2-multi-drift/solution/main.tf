# Harrow Ironworks — pour-floor control files, managed as code.
# Every file under furnaces/, recipes/ and molds/ is read by the pour-floor PLCs.

locals {
  quench_seconds = 40
  pour_temp_c    = 1450
}

# The heat lot is stamped on every casting. It is generated once per campaign.
resource "random_id" "heat_lot" {
  byte_length = 3
}

resource "local_file" "furnace_a" {
  filename = "${path.module}/furnaces/furnace-a.cfg"
  content  = <<-EOT
    furnace       = A
    heat_lot      = HL-${random_id.heat_lot.hex}
    quench_seconds = ${local.quench_seconds}
  EOT
}

resource "local_file" "furnace_b" {
  filename = "${path.module}/furnaces/furnace-b.cfg"
  content  = <<-EOT
    furnace       = B
    heat_lot      = HL-${random_id.heat_lot.hex}
    ladle_preheat_c = 600
  EOT
}

resource "local_file" "bronze_pour" {
  filename = "${path.module}/recipes/bronze-pour.cfg"
  content  = <<-EOT
    alloy         = bronze-b10
    pour_temp_c   = ${local.pour_temp_c}
  EOT
}

resource "local_file" "shift_board" {
  filename = "${path.module}/floor/shift-board.txt"
  content  = "Campaign heat lot HL-${random_id.heat_lot.hex}, pour at ${local.pour_temp_c} C\n"
}

output "heat_lot" {
  value = "HL-${random_id.heat_lot.hex}"
}
