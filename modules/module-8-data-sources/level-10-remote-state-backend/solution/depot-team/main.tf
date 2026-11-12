# The tram depot team's configuration. Their published facts are the outputs below.

variable "track_count" {
  type    = number
  default = 6
}

output "depot_code" {
  value = "NRT-04"
}

output "track_count" {
  value = var.track_count
}

output "first_departure" {
  value = "05:12"
}
