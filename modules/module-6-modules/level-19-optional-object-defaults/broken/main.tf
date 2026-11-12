variable "queues" {
  description = "Queues to staff; only skill is required"
  default = {
    night_desk = { skill = "triage" }
    sales_line = { skill = "upgrades", bitrate_kbps = 64 }
    billing    = { skill = "refunds", jingle = false }
  }
}

module "routing" {
  source = "./modules/routing"

  queues = var.queues
}

resource "local_file" "rota" {
  filename = "${path.module}/queues/rota.txt"
  content  = "${join("\n", module.routing.rota)}\n"
}

output "rota" {
  value = module.routing.rota
}
