variable "owner" {
  type    = string
  default = "Brita Hallgren"
}

variable "catch" {
  type    = list(string)
  default = ["herring", "mackerel", "pike-perch"]
}

module "stall" {
  source = "./modules/stall"

  owner = var.owner
  catch = var.catch
}

resource "local_file" "board" {
  filename = "${path.module}/board/stall.json"
  content  = jsonencode(module.stall)
}

output "fields" {
  value = sort(keys(module.stall))
}
