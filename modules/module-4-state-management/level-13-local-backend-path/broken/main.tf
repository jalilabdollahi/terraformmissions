# Sunrise Tuk-Tuk Tours: city tour timetable.
# The tuk-tuk name and departure minute were generated once and are printed on
# every timetable. The backend path in terraform.tf was changed during a repo
# reshuffle. See NOTES.txt.

resource "random_pet" "tuktuk_name" {
  length = 2
  prefix = "tuk"
}

resource "random_integer" "departure_minute" {
  min = 0
  max = 59
}

resource "local_file" "timetable" {
  filename = "${path.module}/timetable/morning.txt"
  content  = "${random_pet.tuktuk_name.id} departs at minute ${random_integer.departure_minute.result}\n"
}
