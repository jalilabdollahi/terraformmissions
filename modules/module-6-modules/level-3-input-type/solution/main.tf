variable "gusts" {
  type        = string
  description = "Gust readings in km/h, comma separated"
  default     = "12,18,25,28"
}

module "windcheck" {
  source = "./modules/windcheck"

  field     = "Skagen Dunes"
  gusts_kmh = split(",", var.gusts)
}

resource "local_file" "board" {
  filename = "${path.module}/board/morning.txt"
  content  = "${module.windcheck.field_name}: ${module.windcheck.verdict} (peak ${module.windcheck.peak_kmh} km/h)\n"
}

output "verdict" {
  value = module.windcheck.verdict
}
