# Pellham Municipal Court — docket seals and courtroom call-signs.
# The seal is stamped on every filed document; courtroom call-signs are displayed on the
# lobby boards and in the clerk's paper binders. None of them may be re-rolled.

locals {
  courtrooms = toset(["c1", "c2", "c3"])
}

resource "random_id" "docket_seal" {
  byte_length = 4
}

resource "random_pet" "courtroom" {
  for_each  = local.courtrooms
  length    = 2
  separator = "-"
  prefix    = "ct"
}

resource "local_file" "docket" {
  for_each = local.courtrooms
  filename = "${path.module}/docket/${each.key}.txt"
  content  = "courtroom ${each.key} call-sign ${random_pet.courtroom[each.key].id} seal ${random_id.docket_seal.hex}\n"
}

output "docket_seal" {
  value = random_id.docket_seal.hex
}

output "call_signs" {
  value = { for k, p in random_pet.courtroom : k => p.id }
}
