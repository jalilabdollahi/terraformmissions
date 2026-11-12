variable "belts" { type = list(string) }
resource "random_id" "belt" {
  for_each    = toset(var.belts)
  byte_length = 3
}
output "belt_ids" {
  value = { for k, r in random_id.belt : k => r.hex }
}
