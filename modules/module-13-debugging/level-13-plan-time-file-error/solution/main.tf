# Harbour Lane recording studio - session paperwork.

locals {
  takes = ["take 1: drums too loud", "take 2: good", "take 3: fade out early"]
}

# The engineer's raw notes, written from the takes list.
resource "local_file" "session_notes" {
  filename = "${path.module}/studio/notes.txt"
  content  = "${join("\n", local.takes)}\n"
}

locals {
  notes_text = local_file.session_notes.content
  take_count = length(compact(split("\n", local.notes_text)))
}

# The producer's track sheet quotes the notes.
resource "local_file" "track_sheet" {
  filename = "${path.module}/studio/track-sheet.txt"
  content  = "Session notes (${local.take_count} takes):\n${local.notes_text}"
}

output "take_count" {
  value = local.take_count
}
