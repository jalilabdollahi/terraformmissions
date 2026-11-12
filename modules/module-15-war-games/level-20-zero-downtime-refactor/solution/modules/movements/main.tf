variable "springs" {
  type = set(string)
}

resource "random_id" "spring_serial" {
  for_each    = var.springs
  byte_length = 4
}

output "serials" {
  value = { for k, v in random_id.spring_serial : k => v.hex }
}
