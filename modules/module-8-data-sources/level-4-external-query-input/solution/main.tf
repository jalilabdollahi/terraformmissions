# Falconry mews: a bird flies best at a fraction of its peak body weight.
# bin/flying-weight.sh does the arithmetic; Terraform only supplies the bird and the numbers.

variable "bird" {
  type    = string
  default = "Saker falcon Tamsin"
}

variable "weight_g" {
  type    = number
  default = 1020
}

variable "target_pct" {
  type    = number
  default = 94
}

data "external" "flying_weight" {
  program = ["bash", "${path.module}/bin/flying-weight.sh"]

  query = {
    bird       = var.bird
    weight_g   = var.weight_g
    target_pct = var.target_pct
  }
}

resource "local_file" "weigh_in" {
  filename = "${path.module}/mews/weigh-in.txt"
  content  = <<-EOT
    Bird: ${data.external.flying_weight.result.bird}
    Flying weight: ${data.external.flying_weight.result.flying_weight_g} g
    Grams to lose: ${data.external.flying_weight.result.grams_to_lose} g
    Advice: ${data.external.flying_weight.result.advice}
  EOT
}

output "flying_weight_g" {
  value = tonumber(data.external.flying_weight.result.flying_weight_g)
}

output "advice" {
  value = data.external.flying_weight.result.advice
}
