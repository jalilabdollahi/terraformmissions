variable "pieces" {
  type    = list(string)
  default = ["vase", "bowl", "ornament"]
}

module "piece" {
  source   = "./modules/glassware"
  for_each = var.pieces

  kind = each.key
}

resource "local_file" "board" {
  filename = "${path.module}/kiln/schedule.txt"
  content  = join("", [for k, m in module.piece : "${k}:${m.hours}h\n"])
}

output "vase_hours" {
  value = module.piece["Vase"].hours
}
