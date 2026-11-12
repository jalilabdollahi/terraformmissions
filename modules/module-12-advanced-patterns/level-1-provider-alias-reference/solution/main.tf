# Fossil dig site specimen tags.
# Each pit has its own provider configuration (an alias), so the audit trail can say
# which pit a tag came from. Two resources were wired up in a hurry.

provider "random" {
  alias = "north_pit"
}

provider "random" {
  alias = "south_pit"
}

resource "random_id" "north_tag" {
  byte_length = 3
  provider    = random.north_pit
}

resource "random_id" "south_tag" {
  byte_length = 3
  provider    = random.south_pit
}

resource "local_file" "dig_log" {
  filename = "${path.module}/dig/specimens.txt"
  content  = <<-EOT
    north pit tag: ${random_id.north_tag.hex}
    south pit tag: ${random_id.south_tag.hex}
  EOT
}

output "north_tag" {
  value = random_id.north_tag.hex
}

output "south_tag" {
  value = random_id.south_tag.hex
}
