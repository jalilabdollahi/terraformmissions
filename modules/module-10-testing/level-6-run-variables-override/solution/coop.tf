variable "coop_sqft" {
  description = "Floor area of the henhouse in square feet."
  type        = number
  default     = 120
}

variable "stock" {
  description = "Hens per breed in the coop."
  type        = map(number)
  default = {
    rhode_red = 10
    sussex    = 4
  }
}

locals {
  hens_total = sum(values(var.stock))
  per_hen   = var.coop_sqft / local.hens_total
}

output "hens_total" {
  value = local.hens_total
}

output "sqft_per_hen" {
  value = local.per_hen
}

output "overstocked" {
  value = local.per_hen < 5
}
