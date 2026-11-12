resource "random_integer" "bench_slot" {
  min = 1
  max = 6
}

module "mainspring" {
  source = "./modules/mainspring"
}

output "ticket" {
  value = "bench-${random_integer.bench_slot.result}/turns-${module.mainspring.turns}"
}
