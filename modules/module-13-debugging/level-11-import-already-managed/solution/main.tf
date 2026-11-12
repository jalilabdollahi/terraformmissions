# Rewind Jukebox Restorations - machine registry.

resource "random_integer" "service_code" {
  min = 100
  max = 999
}

resource "local_file" "bench_ledger" {
  filename = "${path.module}/ledger/bench.txt"
  content  = "Service code on the bench: ${random_integer.service_code.result}\n"
}

output "service_code" {
  value = random_integer.service_code.result
}
