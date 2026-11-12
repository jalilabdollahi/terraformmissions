# Film-lab batch tags for Silverhalide Darkroom.
# Each developing batch gets a tag that is stamped on the canister and typed
# into the logbook: exactly 12 lowercase hexadecimal characters.

resource "random_id" "batch" {
  byte_length = 12
}

resource "local_file" "logbook_entry" {
  filename = "${path.module}/logbook/batch-${random_id.batch.b64_url}.txt"
  content  = "Batch tag: ${random_id.batch.b64_url}\nChemistry: D-76 1+1\nTemperature: 20C\n"
}

output "batch_tag" {
  value = random_id.batch.b64_url
}
