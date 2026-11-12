# The bus depot team's configuration. Their published facts are the outputs below.

variable "bay_count" {
  type    = number
  default = 6
}

output "depot_code" {
  value = "NBD-04"
}

output "bay_count" {
  value = var.bay_count
}

output "first_departure" {
  value = "05:12"
}
