variable "crew" { type = map(string) }
variable "shift_hours" {
  type    = number
  default = 12
}
resource "random_pet" "member" {
  for_each  = var.crew
  length    = 2
  separator = "-"
}
resource "local_file" "card" {
  for_each = var.crew
  filename = "${path.root}/cards/${each.key}.txt"
  content  = <<-EOT
    ${each.key} / ${each.value}
    call-sign ${random_pet.member[each.key].id}
    shift ${var.shift_hours}h
  EOT
}
output "member_names" {
  value = { for k, p in random_pet.member : k => p.id }
}
