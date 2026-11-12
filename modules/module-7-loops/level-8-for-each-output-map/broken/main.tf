# Ticket stubs for the Harbour Film Festival.
# screenings maps a film's slug to its start time.

resource "local_file" "ticket" {
  for_each = var.screenings
  filename = "${path.module}/tickets/${each.key}.txt"
  content  = "ADMIT ONE - ${each.key} at ${each.value}\n"
}

output "ticket_files" {
  description = "Path of each ticket, keyed by film slug."
  value       = local_file.ticket.filename
}

output "film_count" {
  value = length(local_file.ticket)
}
