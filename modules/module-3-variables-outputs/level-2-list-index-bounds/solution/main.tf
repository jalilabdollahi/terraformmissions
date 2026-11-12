# Harbourlight ferry — crossing timetable.
# The notice board prints the first and the last sailing of the day.
# Sailings are listed in order, earliest first.

variable "service_name" {
  type    = string
  default = "Harbourlight Ferry"
}

variable "departures" {
  description = "Departure times from the north pier, earliest first."
  type        = list(string)
  default     = ["06:15", "09:40", "13:05", "17:30"]
}

locals {
  first_sailing = var.departures[0]
  last_sailing  = var.departures[length(var.departures) - 1]
}

resource "local_file" "notice_board" {
  filename = "${path.module}/board/notice.txt"
  content  = <<-EOT
    ${var.service_name}
    First sailing: ${local.first_sailing}
    Last sailing:  ${local.last_sailing}
  EOT
}

output "last_departure" {
  value = local.last_sailing
}

output "sailings_per_day" {
  value = length(var.departures)
}
