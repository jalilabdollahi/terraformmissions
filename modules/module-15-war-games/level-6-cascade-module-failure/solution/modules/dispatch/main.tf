variable "loads" {
  description = "Sorter name => total bags per minute."
  type        = map(number)
}

locals {
  names   = keys(var.loads)
  peak    = max(values(var.loads)...)
  busiest = [for k in local.names : k if var.loads[k] == local.peak][0]
}

output "total_capacity" {
  value = sum(values(var.loads))
}

output "busiest" {
  value = local.busiest
}

resource "local_file" "board" {
  filename = "${path.root}/sortation/dispatch-board.txt"
  content  = "total ${sum(values(var.loads))} bpm, busiest ${local.busiest}\n"
}
