locals {
  subnet = cidrsubnet("10.0.0.0/16", 8, 1)
}

output "subnet" {
  value = local.subnet
}
