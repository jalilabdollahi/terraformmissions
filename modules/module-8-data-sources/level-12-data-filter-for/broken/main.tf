# Kayak club: the fleet register is a JSON file kept by the boat shed. The rota needs the boats
# that can go out today, grouped by class, and the list that must go to the repair bench.

data "local_file" "register" {
  filename = "${path.module}/club/fleet.json"
}

locals {
  fleet = jsondecode(data.local_file.register.content).fleet

  ready_by_class = { for boat in local.fleet : boat.class => boat.id if boat.state == "serviceable" }
  needs_repair   = [for boat in local.fleet : boat.id if boat.status == "repair"]
}

resource "local_file" "rota" {
  filename = "${path.module}/club/rota.txt"
  content = join("\n", concat(
    [for class, ids in local.ready_by_class : "${class}: ${join(", ", ids)}"],
    ["bench: ${join(", ", local.needs_repair)}", ""]
  ))
}

output "ready_by_class" {
  value = local.ready_by_class
}

output "needs_repair" {
  value = local.needs_repair
}
