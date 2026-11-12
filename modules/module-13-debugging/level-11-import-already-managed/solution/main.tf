# Rewind Telephone Box Restorations - telephone box registry.

resource "random_integer" "service_code" {
  min = 100
  max = 999
}

resource "local_file" "kiosk_ledger" {
  filename = "${path.module}/ledger/kiosk.txt"
  content  = "Service code on the kiosk: ${random_integer.service_code.result}\n"
}

output "service_code" {
  value = random_integer.service_code.result
}
