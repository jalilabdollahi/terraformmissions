# Kestrel Valley gondola line - cabin tags and station load limits.
# State is the local terraform.tfstate file next to this configuration.

locals {
  cabins = toset(["alpine", "birch", "cedar", "dale"])
}

resource "random_id" "cabin_tag" {
  for_each    = local.cabins
  byte_length = 4
}

module "station" {
  source   = "./modules/station"
  stations = toset(["base", "top"])
}

resource "local_file" "inspection_log" {
  filename = "${path.module}/out/inspection-log.txt"
  content = join("\n", concat(
    [for k in sort(keys(random_id.cabin_tag)) : "cabin ${k} ${random_id.cabin_tag[k].hex}"],
    [for k in sort(keys(module.station.limits)) : "limit ${k} ${module.station.limits[k]}"],
    [""],
  ))
}
