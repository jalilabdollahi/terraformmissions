# Hollowbrook Saffron Growers' Co-op - fields team's own stack (to be retired, see ../all-in-one).

resource "random_id" "batch" {
  byte_length = 5
}

resource "random_integer" "quota" {
  min = 200
  max = 400
}

resource "local_file" "ledger" {
  filename = "${path.module}/../../out/fields-ledger.txt"
  content  = "team fields batch ${random_id.batch.hex} quota ${random_integer.quota.result}\n"
}

output "batch" {
  value = random_id.batch.hex
}
