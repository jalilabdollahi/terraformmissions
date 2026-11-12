# Club Velvet: staff door codes.
# One code per entrance, printed on staff cards. The DJ dj code leaked.

locals {
  entrances = toset(["main", "vip", "cloakroom", "dj"])
}

resource "random_integer" "door_code" {
  for_each = local.entrances
  min      = 1000
  max      = 9999
}

resource "local_file" "staff_card" {
  filename = "${path.module}/cards/staff.txt"
  content = join("\n", concat(
    [for e in sort(keys(random_integer.door_code)) : "${e}: ${random_integer.door_code[e].result}"],
    [""]
  ))
}
