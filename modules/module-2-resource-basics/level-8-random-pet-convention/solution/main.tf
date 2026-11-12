# Telescope nicknames for the Cragmoor amateur observatory.
# Members book the instruments by nickname on the shared calendar, and the
# booking sheet only recognises names of the form  scope-<word>-<word>
# (all lowercase, hyphen separated), e.g. scope-brave-heron.

resource "random_pet" "refractor" {
  prefix    = "scope"
  length    = 2
  separator = "-"
}

resource "random_pet" "reflector" {
  prefix    = "scope"
  length    = 2
  separator = "-"
}

resource "local_file" "booking_sheet" {
  filename = "${path.module}/calendar/instruments.txt"
  content  = "refractor: ${random_pet.refractor.id}\nreflector: ${random_pet.reflector.id}\n"
}

output "refractor_nickname" {
  value = random_pet.refractor.id
}

output "reflector_nickname" {
  value = random_pet.reflector.id
}
