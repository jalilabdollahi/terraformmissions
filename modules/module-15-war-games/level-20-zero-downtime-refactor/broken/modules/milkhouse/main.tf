variable "vats" {
  type = set(string)
}

resource "random_id" "vat_serial" {
  for_each    = var.vats
  byte_length = 4
}

output "serials" {
  value = { for k, v in random_id.vat_serial : k => v.hex }
}
