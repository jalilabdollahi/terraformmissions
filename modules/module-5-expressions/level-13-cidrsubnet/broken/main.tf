# BUG: cidrsubnet("10.0.0.0/24", 8, 1) tries to add 8 bits to a /24,
# producing a /32, and then index 1 overflows the available addresses.

locals {
  subnet = cidrsubnet("10.0.0.0/24", 8, 1)
}

output "subnet" {
  value = local.subnet
}
