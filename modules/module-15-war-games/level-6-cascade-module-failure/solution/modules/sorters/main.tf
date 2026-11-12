variable "belt_serials" {
  type = map(string)
}

variable "capacity" {
  description = "Belt name => bags per minute."
  type        = map(number)
}

variable "assignments" {
  description = "Sorter name => belts feeding it."
  type        = map(list(string))
}

resource "random_pet" "sorter" {
  for_each = var.assignments
  length   = 2
}

resource "local_file" "sort_plan" {
  for_each = var.assignments
  filename = "${path.root}/sortation/${each.key}.txt"
  content = join("\n", concat(
    ["sorter ${each.key} (${random_pet.sorter[each.key].id})"],
    [for b in each.value : "  ${b} serial=${var.belt_serials[b]} cap=${var.capacity[b]}"],
    [""]
  ))
}

output "loads" {
  value = { for s, bs in var.assignments : s => sum([for b in bs : var.capacity[b]]) }
}
