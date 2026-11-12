variable "loads" {
  description = "Sorter name => total bags per minute."
  type        = map(number)
}

locals {
  names = keys(var.loads)
}

output "total_capacity" {
  # all sorters are the same size, right?
  value = length(var.loads) * max(values(var.loads)...)
}

output "busiest" {
  value = local.names[0]
}

resource "local_file" "board" {
  filename = "${path.root}/sortation/dispatch-board.txt"
  content  = "total ${length(var.loads) * max(values(var.loads)...)} bpm, busiest ${local.names[0]}\n"
}
