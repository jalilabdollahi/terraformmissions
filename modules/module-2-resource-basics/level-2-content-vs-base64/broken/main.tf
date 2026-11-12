# Lift-status board for Pinecrest Ridge.
# The signage controller wants a real PNG on disk for the "closed" badge.
# We embed it as base64 so the repo stays text-only.

locals {
  closed_badge_png = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="
  board_title      = "PINECREST RIDGE - LIFT STATUS"
}

resource "local_file" "closed_badge" {
  filename       = "${path.module}/signage/lift-closed.png"
  content        = local.closed_badge_png
  content_base64 = local.closed_badge_png
}

resource "local_file" "board_header" {
  filename = "${path.module}/signage/header.txt"
  content  = "${local.board_title}\n"
}

output "badge_file" {
  value = local_file.closed_badge.filename
}

output "badge_sha256" {
  value = local_file.closed_badge.content_sha256
}
