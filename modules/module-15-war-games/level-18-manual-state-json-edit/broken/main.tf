# Kestrel Valley truffle-hunting estate - hound tags and grove harvest quotas.
# State is the local terraform.tfstate file next to this configuration.

locals {
  hounds = toset(["bruno", "fig", "luna", "pippa"])
}

resource "random_id" "hound_tag" {
  for_each    = local.hounds
  byte_length = 4
}

module "grove" {
  source   = "./modules/grove"
  groves = toset(["oak", "hazel"])
}

resource "local_file" "inspection_log" {
  filename = "${path.module}/out/inspection-log.txt"
  content = join("\n", concat(
    [for k in sort(keys(random_id.hound_tag)) : "hound ${k} ${random_id.hound_tag[k].hex}"],
    [for k in sort(keys(module.grove.quotas)) : "quota ${k} ${module.grove.quotas[k]}"],
    [""],
  ))
}
