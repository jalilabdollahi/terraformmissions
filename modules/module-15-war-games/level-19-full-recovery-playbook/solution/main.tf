# Aurelia Ice Camp - power, radio and the nightly beacon check.

module "power" {
  source = "./modules/power"
}

module "comms" {
  source       = "./modules/comms"
  generator_id = module.power.generator_id
}

resource "local_file" "camp_manifest" {
  filename = "${path.module}/out/camp-manifest.txt"
  content  = "power generator ${module.power.generator_id}\nfuel ${module.power.fuel}\nradio channel ${module.comms.channel}\n"
}

resource "terraform_data" "beacon" {
  input = module.comms.channel

  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/out && printf 'beacon OK for %s\\n' '${module.power.generator_id}' > ${path.module}/out/beacon.txt"
  }
}

output "fuel_litres" {
  value = module.power.fuel
}
