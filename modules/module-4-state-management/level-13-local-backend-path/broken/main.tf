# Tidewater Ferries: harbour timetable.
# The ferry name and departure minute were generated once and are printed on
# every timetable. The backend path in terraform.tf was changed during a repo
# reshuffle. See NOTES.txt.

resource "random_pet" "ferry_name" {
  length = 2
  prefix = "mv"
}

resource "random_integer" "departure_minute" {
  min = 0
  max = 59
}

resource "local_file" "timetable" {
  filename = "${path.module}/timetable/morning.txt"
  content  = "${random_pet.ferry_name.id} departs at minute ${random_integer.departure_minute.result}\n"
}
