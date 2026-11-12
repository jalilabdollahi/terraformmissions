variable "performer" {
  type    = string
  default = "Marta Vik"
}

variable "setlist" {
  type    = list(string)
  default = ["ballad", "jig", "waltz"]
}

module "busker" {
  source = "./modules/busker"

  performer = var.performer
  setlist   = var.setlist
}

resource "local_file" "board" {
  filename = "${path.module}/board/busker.json"
  content  = jsonencode(module.busker)
}

output "fields" {
  value = sort(keys(module.busker))
}
