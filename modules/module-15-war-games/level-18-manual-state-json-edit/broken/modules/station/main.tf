variable "stations" {
  type = set(string)
}

resource "random_integer" "load_limit" {
  for_each = var.stations
  min      = 1000
  max      = 9999
}

output "limits" {
  value = { for k, r in random_integer.load_limit : k => r.result }
}
