variable "belt_ids" { type = map(string) }
variable "assignments" { type = map(list(string)) }
resource "random_pet" "sorter" {
  for_each = var.assignments
  length   = 2
}
output "loads" {
  value = { for s, bs in var.assignments : s => length(bs) * 20 }
}
