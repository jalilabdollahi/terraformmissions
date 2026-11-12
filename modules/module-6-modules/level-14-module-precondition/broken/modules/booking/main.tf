variable "flight_class" {
  type = string
}

variable "passengers" {
  type = number
}

locals {
  summary = "${var.flight_class} flight: ${var.passengers} passengers"
}

resource "terraform_data" "basket" {
  input = local.summary

  lifecycle {
    precondition {
      condition     = var.flight_class == "sunrise" ? var.passengers <= 12 : var.passengers <= 8
      error_message = "Basket overloaded: sunrise flights carry at most 8 passengers, standard flights at most 12."
    }
    precondition {
      condition     = var.passengers >= 1
      error_message = "A flight needs at least one passenger."
    }
  }
}

output "summary" {
  value = terraform_data.basket.output
}
