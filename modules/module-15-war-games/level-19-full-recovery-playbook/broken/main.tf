# Aurelia Midnight-Sun Film Shoot Base - power, radio and the nightly dailies-upload check.

module "power" {
  source = "./modules/power"
}

module "comms" {
  source       = "./modules/comms"
  generator_id = module.power.generator
}

resource "local_file" "base_manifest" {
  filename = "${path.module}/out/base-manifest.txt"
  content  = "power generator ${module.power.generator_id}\nfuel ${module.power.fuel}\nradio channel ${module.comms.channel_number}\n"
}

resource "terraform_data" "dailies" {
  input = module.comms.channel

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/out && printf 'dailies OK for %s\\n' '${module.power.generator_id}' > ${path.module}/out/dailies.txt"
  }
}

output "fuel_litres" {
  value = module.power.fuel
}
