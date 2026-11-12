# Radio call signs for the Skyward Air Cadets.
# Every cadet is given a random call sign, which is then printed on a wing card.

resource "random_pet" "callsign" {
  for_each  = toset(var.cadets)
  length    = 2
  separator = "-"
  prefix    = "sky"
}

resource "local_file" "wing_card" {
  filename = "${path.module}/wings/${random_pet.callsign.id}.txt"
  content  = "Cadet wing card - call sign ${random_pet.callsign.id}\n"
}

output "call_signs" {
  value = { for cadet, p in random_pet.callsign : cadet => p.id }
}
