variable "canal" {
  type        = string
  description = "Name of the waterway being charged"
}

variable "length_m" {
  type        = number
  description = "Vessel length in metres"
}

variable "beam_m" {
  type        = number
  description = "Vessel width in metres"
}

resource "terraform_data" "toll" {
  input = {
    canal      = var.canal
    toll_pence = var.beam_m * 1000 + var.length_m * 250
  }
}

output "toll_pence" {
  value = terraform_data.toll.output.toll_pence
}
