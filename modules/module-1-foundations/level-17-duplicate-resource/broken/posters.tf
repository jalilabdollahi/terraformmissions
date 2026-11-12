# Added for the autumn season (copied from the comet poster above).
resource "local_file" "poster" {
  filename = "${path.module}/posters/eclipse-tour.txt"
  content  = "ECLIPSE TOUR\nSaturday 15:30 - ${var.venue}\nTickets at the door.\n"
}
