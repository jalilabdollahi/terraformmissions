# Pixel Palace arcade - cabinet registry.

resource "random_integer" "cabinet_code" {
  min = 100
  max = 999
}

resource "local_file" "floor_ledger" {
  filename = "${path.module}/ledger/floor.txt"
  content  = "Cabinet code on the floor: ${random_integer.cabinet_code.result}\n"
}

output "cabinet_code" {
  value = random_integer.cabinet_code.result
}
