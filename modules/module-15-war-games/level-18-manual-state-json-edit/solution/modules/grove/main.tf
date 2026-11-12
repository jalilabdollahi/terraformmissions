variable "groves" {
  type = set(string)
}

resource "random_integer" "harvest_quota" {
  for_each = var.groves
  min      = 1000
  max      = 9999
}

output "quotas" {
  value = { for k, r in random_integer.harvest_quota : k => r.result }
}
