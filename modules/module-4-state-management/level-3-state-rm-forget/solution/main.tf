# Meadowbrook Stud: horse records.
# The stud book belongs to the breeders' association now.

resource "random_id" "season_tag" {
  byte_length = 3
  prefix      = "foal-"
}

resource "local_file" "vet_log" {
  filename = "${path.module}/records/vet-log.txt"
  content  = "Season ${random_id.season_tag.hex}: 14 mares inspected, no strangles.\n"
}
