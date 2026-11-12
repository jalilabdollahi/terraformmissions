variable "boat" {
  type = string
}

resource "random_integer" "supply" {
  min = 100
  max = 999
  keepers = {
    boat = var.boat
  }
}

output "supply_batch" {
  value = random_integer.supply.result
}
