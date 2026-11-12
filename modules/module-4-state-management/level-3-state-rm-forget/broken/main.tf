# Meadowbrook Apiary: hive records.
# The queen registry now belongs to the breeders' association. We must stop
# managing it, but the file itself has to survive on disk.

resource "random_id" "season_tag" {
  byte_length = 3
  prefix      = "bee-"
}

resource "local_file" "inspection_log" {
  filename = "${path.module}/records/inspection-log.txt"
  content  = "Season ${random_id.season_tag.hex}: 14 hives inspected, no foulbrood.\n"
}

resource "local_file" "queen_registry" {
  filename = "${path.module}/records/queen-registry.txt"
  content  = "Queens on record: Carniolan x3, Buckfast x2, Italian x1\n"
}
