# Tool library: the stock register is a JSON file kept in the stock room. The rota needs the tools
# that can go out today, grouped by class, and the list that must go to the mending corner.

data "local_file" "register" {
  filename = "${path.module}/library/stock.json"
}

locals {
  stock = jsondecode(data.local_file.register.content).stock

  ready_by_class = { for tool in local.stock : tool.class => tool.id... if tool.status == "serviceable" }
  needs_repair   = [for tool in local.stock : tool.id if tool.status == "repair"]
}

resource "local_file" "rota" {
  filename = "${path.module}/library/rota.txt"
  content = join("\n", concat(
    [for class, ids in local.ready_by_class : "${class}: ${join(", ", ids)}"],
    ["mending: ${join(", ", local.needs_repair)}", ""]
  ))
}

output "ready_by_class" {
  value = local.ready_by_class
}

output "needs_repair" {
  value = local.needs_repair
}
