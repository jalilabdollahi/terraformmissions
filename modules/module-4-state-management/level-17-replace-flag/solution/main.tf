# Orpheum Theatre: crew door codes.
# One code per entrance, printed on crew cards. The booth code leaked.

locals {
  entrances = toset(["stage", "pit", "box-office", "booth"])
}

resource "random_integer" "door_code" {
  for_each = local.entrances
  min      = 1000
  max      = 9999
}

resource "local_file" "crew_card" {
  filename = "${path.module}/cards/crew.txt"
  content = join("\n", concat(
    [for e in sort(keys(random_integer.door_code)) : "${e}: ${random_integer.door_code[e].result}"],
    [""]
  ))
}
