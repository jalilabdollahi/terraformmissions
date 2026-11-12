# Tessera Research Station — address plan for the internal network.
# Each zone gets its own block of the station's range, all the same size.

variable "base_cidr" {
  type    = string
  default = "10.77.0.0/22"
}

variable "subnet_prefix" {
  type        = number
  description = "Prefix length of every zone block, e.g. 26 for a /26."
  default     = 26
}

variable "zones" {
  type    = list(string)
  default = ["airlock", "lab", "galley", "hab-a", "hab-b", "hydroponics"]
}

locals {
  newbits = 2
  zone_cidrs = {
    for index, zone in var.zones :
    zone => cidrsubnet(var.base_cidr, local.newbits, index)
  }
}

resource "local_file" "address_plan" {
  filename = "${path.module}/plan/addresses.txt"
  content  = "${join("\n", [for zone, cidr in local.zone_cidrs : "${zone} ${cidr}"])}\n"
}

output "zone_cidrs" {
  value = local.zone_cidrs
}

output "hosts_per_zone" {
  value = pow(2, 32 - var.subnet_prefix) - 2
}
