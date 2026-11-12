variable "generator_id" {
  type = string
}

resource "random_id" "radio_key" {
  byte_length = 3
}

resource "random_integer" "channel" {
  min = 10
  max = 99
}

resource "local_file" "comms_sheet" {
  filename = "${path.root}/out/comms-sheet.txt"
  content  = "radio ${random_id.radio_key.hex} channel ${random_integer.channel.result} powered-by ${var.generator_id}\n"
}

output "channel" {
  value = random_integer.channel.result
}
