# Mascot names for the Coastwatch lifeboat stations.
# The code was just migrated from `count` to `for_each`, so that stations are
# identified by name instead of by their position in the list.
# The mascots are already painted on the boats: they must not change.

resource "random_pet" "mascot" {
  for_each  = toset(var.stations)
  length    = 2
  separator = "-"
}

resource "local_file" "roster" {
  filename = "${path.module}/roster.txt"
  content = join("\n", [
    for s in var.stations : "${s}: ${random_pet.mascot[s].id}"
  ])
}
