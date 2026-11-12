variable "regional_id" {
  type = string
}

resource "random_integer" "channel" {
  min = 100
  max = 899

  keepers = {
    id = var.regional_id
  }
}

module "post" {
  source = "./modules/post"

  callsign = var.base_callsign
}

output "channel" {
  value = random_integer.channel.result
}

output "beacon_serial" {
  value = module.post.beacon_serial
}
