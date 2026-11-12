# Cedarbank Sawmill — kiln drying pipeline.
# Per lot: a tag number (printed on the pallet wrap), a handshake with the kiln controller,
# and a paper ticket for the yard office. Tag numbers are on pallets already - they never change.

locals {
  lots = {
    oak  = { kiln = "K-1" }
    pine = { kiln = "K-2" }
    ash  = { kiln = "K4" }
  }
}

resource "random_integer" "tag" {
  for_each = local.lots
  min      = 1000
  max      = 9999
}

resource "terraform_data" "kiln_run" {
  for_each         = local.lots
  triggers_replace = [each.value.kiln, random_integer.tag[each.key].result]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/handshake.sh ${each.key} ${each.value.kiln} ${random_integer.tag[each.key].result}"
  }
}

resource "local_file" "ticket" {
  for_each = local.lots
  filename = "${path.module}/tickets/${each.key}.txt"
  content  = <<-EOT
    LOT   ${upper(each.key)}
    KILN  ${each.value.kiln}
    TAG   ${random_integer.tag[each.key].result}
    RUN   ${terraform_data.kiln_run[each.key].id}
  EOT
}

output "pallet_tags" {
  value = { for k, t in random_integer.tag : k => t.result }
}
