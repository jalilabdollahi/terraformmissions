locals {
  vats    = toset(["curd", "whey", "cold1", "cold2"])
  rooms = ["r2", "r1", "r3"]
}

resource "random_id" "vat_serial" {
  for_each    = local.vats
  byte_length = 4
}

resource "random_integer" "room_shelves" {
  count = length(local.rooms)
  min   = 500
  max   = 5000
}

resource "random_uuid" "licence" {}

resource "time_static" "first_churn" {}

resource "null_resource" "cip_cycle" {
  triggers = {
    cycle = "weekly"
  }
}

resource "random_integer" "trial_batch" {
  min = 1
  max = 9
}

module "rennet" {
  source = "./modules/rennet"
}

resource "local_file" "dairy_sheet" {
  filename = "${path.module}/out/dairy-sheet.txt"
  content = join("\n", concat(
    [for k in sort(keys(random_id.vat_serial)) : "vat ${k} ${random_id.vat_serial[k].hex}"],
    sort([for i, k in local.rooms : "room ${k} ${random_integer.room_shelves[i].result}"]),
    [
      "licence ${random_uuid.licence.result}",
      "first churn ${time_static.first_churn.rfc3339}",
      "cip ${null_resource.cip_cycle.id}",
    ],
    [for k in sort(keys(module.rennet.strains)) : "rennet ${k} ${module.rennet.strains[k]}"],
    [""],
  ))
}

output "dairy_sheet_path" {
  value = local_file.dairy_sheet.filename
}
