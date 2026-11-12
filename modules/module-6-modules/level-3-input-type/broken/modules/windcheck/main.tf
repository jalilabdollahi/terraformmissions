variable "field" {
  type = string
}

variable "gusts_kmh" {
  type = list(number)
}

locals {
  peak = max(var.gusts_kmh...)
}

output "field_name" {
  value = var.field
}

output "peak_kmh" {
  value = local.peak
}

output "verdict" {
  value = local.peak <= 30 ? "fly all kites" : (local.peak <= 45 ? "stunt kites only" : "grounded")
}
