# Meadowbrook Stud: horse records.
# The stud book now belongs to the breeders' association. We must stop
# managing it, but the file itself has to survive on disk.

resource "random_id" "season_tag" {
  byte_length = 3
  prefix      = "foal-"
}

resource "local_file" "vet_log" {
  filename = "${path.module}/records/vet-log.txt"
  content  = "Season ${random_id.season_tag.hex}: 14 mares inspected, no strangles.\n"
}

resource "local_file" "stud_book" {
  filename = "${path.module}/records/stud-book.txt"
  content  = "Sires on record: Arabian x3, Thoroughbred x2, Quarter Horse x1\n"
}
