locals {
  springs  = toset(["brass", "steel", "coil1", "coil2"])
  stalls = ["h2", "h1", "h3"]
}

resource "random_id" "spring_serial" {
  for_each    = local.springs
  byte_length = 4
}

resource "random_integer" "stall_loads" {
  count = length(local.stalls)
  min   = 500
  max   = 5000
}

resource "random_uuid" "licence" {}

resource "time_static" "first_spin" {}

resource "null_resource" "oil_cycle" {
  triggers = {
    cycle = "weekly"
  }
}

resource "random_integer" "prototype_run" {
  min = 1
  max = 9
}

module "paint" {
  source = "./modules/paint"
}

resource "local_file" "works_sheet" {
  filename = "${path.module}/out/works-sheet.txt"
  content = join("\n", concat(
    [for k in sort(keys(random_id.spring_serial)) : "spring ${k} ${random_id.spring_serial[k].hex}"],
    sort([for i, k in local.stalls : "stall ${k} ${random_integer.stall_loads[i].result}"]),
    [
      "licence ${random_uuid.licence.result}",
      "first spin ${time_static.first_spin.rfc3339}",
      "oil ${null_resource.oil_cycle.id}",
    ],
    [for k in sort(keys(module.paint.coats)) : "paint ${k} ${module.paint.coats[k]}"],
    [""],
  ))
}

output "works_sheet_path" {
  value = local_file.works_sheet.filename
}
