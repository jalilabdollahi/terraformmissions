# Riverside Community Centre - the noticeboard in the main hall.

locals {
  board_file = "${path.module}/board/notices.md"

  intro = "# Community Centre notices\nOpen weekdays 9 to 5 in the main hall.\n"
  events = [
    "14 Nov: winter coat drive",
    "28 Nov: toy swap",
  ]
}

# One owner for the board: the standing text followed by the dated list.
resource "local_file" "noticeboard" {
  filename = local.board_file
  content  = "${local.intro}\n## Events\n${join("\n", [for e in local.events : "- ${e}"])}\n"
}

output "board_path" {
  value = local.board_file
}
