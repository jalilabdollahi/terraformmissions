# Alpine club hut register: the Eagle's Nest hut gets a module of its own.
# The hut key number "Rk9mPg" is stamped on the physical key and listed in HANDOVER.md.
# It must be adopted into Terraform, not regenerated.

module "hut" {
  source = "./modules/hut"
  name   = "eagles-nest"
}

import {
  to = module.hut.random_id.key
  id = "Rk9mPg"
}

output "hut_key" {
  value = module.hut.key_hex
}
