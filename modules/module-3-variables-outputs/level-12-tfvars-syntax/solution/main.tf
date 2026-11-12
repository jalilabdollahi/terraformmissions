# Calder Bay whale-watching sailing notice generator.

resource "local_file" "notice" {
  filename = "${path.module}/notice/sailing.txt"
  content = join("\n", [
    "SAILING NOTICE - ${upper(var.tour_name)}",
    "Seats: ${var.seat_count}",
    "Sailings: ${join(" / ", var.sailing_times)}",
    "Lifejackets compulsory on deck: ${var.lifejackets_required ? "YES" : "no"}",
    "",
  ])
}

output "tour" {
  value = var.tour_name
}

output "seats" {
  value = var.seat_count
}

output "sailings" {
  value = var.sailing_times
}

output "lifejackets_required" {
  value = var.lifejackets_required
}
