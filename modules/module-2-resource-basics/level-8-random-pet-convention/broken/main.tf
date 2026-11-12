# Donkey nicknames for the Cragmoor donkey sanctuary.
# Sponsors book visits with the donkeys by nickname on the shared calendar, and the
# sponsor card only recognises names of the form  donkey-<word>-<word>
# (all lowercase, hyphen separated), e.g. donkey-brave-heron.

resource "random_pet" "jenny" {
  prefix    = "Donkey "
  length    = 3
  separator = "_"
}

resource "random_pet" "jack" {
  prefix    = "donkey"
  length    = 2
  separator = "-"
}

resource "local_file" "sponsor_card" {
  filename = "${path.module}/calendar/donkeys.txt"
  content  = "jenny: ${random_pet.jenny.id}\njack: ${random_pet.jack.id}\n"
}

output "jenny_nickname" {
  value = random_pet.jenny.id
}

output "jack_nickname" {
  value = random_pet.jack.id
}
