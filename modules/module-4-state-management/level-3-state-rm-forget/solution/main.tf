# Meadowbrook Apiary: hive records.
# The queen registry belongs to the breeders' association now.

resource "random_id" "season_tag" {
  byte_length = 3
  prefix      = "bee-"
}

resource "local_file" "inspection_log" {
  filename = "${path.module}/records/inspection-log.txt"
  content  = "Season ${random_id.season_tag.hex}: 14 hives inspected, no foulbrood.\n"
}
