# Ticket stubs for the Marrow Lane Literary Festival.
# sessions maps an event's slug to its start time.

resource "local_file" "ticket" {
  for_each = var.sessions
  filename = "${path.module}/tickets/${each.key}.txt"
  content  = "ADMIT ONE - ${each.key} at ${each.value}\n"
}

output "ticket_files" {
  description = "Path of each ticket, keyed by event slug."
  value       = local_file.ticket.filename
}

output "event_count" {
  value = length(local_file.ticket)
}
