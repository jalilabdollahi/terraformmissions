resource "local_file" "stop_count" {
  filename="${path.module}/depot/stop-count.txt"
  content =  "${length(local.stops)} stops\n"
}

output "timetable_file" {
    value = local_file.timetable.filename
}
