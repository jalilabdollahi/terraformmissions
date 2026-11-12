# Harwick Coastguard pager relays.
# One configuration, two Terraform workspaces: "prod" and "staging". Each relay gets a
# paging key and a card file that the radio room loads. The list of relays per
# environment lives in env/<environment>.json (staging has no relays rolled out yet).

locals {
  env    = terraform.workspace
  relays = jsondecode(file("${path.module}/env/${local.env}.json")).relays
}

# One seed per workspace, created long before the relay rollout.
resource "random_id" "region_seed" {
  byte_length = 6
}

resource "random_id" "relay_key" {
  for_each    = local.relays
  byte_length = 4
}

resource "local_file" "relay_card" {
  for_each = local.relays
  filename = "${path.module}/pagers/${local.env}/${each.key}.card"
  content  = "relay ${each.key} channel ${each.value} key ${random_id.relay_key[each.key].hex}\n"
}

output "region_seed" {
  value = random_id.region_seed.hex
}

output "relay_keys" {
  value = { for k, r in random_id.relay_key : k => r.hex }
}
