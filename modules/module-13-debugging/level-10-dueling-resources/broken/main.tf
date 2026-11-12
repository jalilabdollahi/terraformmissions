# Riverside Community Centre - the noticeboard in the main hall.

locals {
  board_file = "${path.module}/board/notices.md"

  intro = "# Community Centre notices\nOpen weekdays 9 to 5 in the main hall.\n"
  events = [
    "14 Nov: winter coat drive",
    "28 Nov: toy swap",
  ]
}

# Owned by the centre manager: the standing text.
resource "local_file" "board_intro" {
  filename = local.board_file
  content  = local.intro
}

# Owned by the events coordinator: the dated list.
resource "local_file" "board_events" {
  filename = local.board_file
  content  = "\n## Events\n${join("\n", [for e in local.events : "- ${e}"])}\n"
}

output "board_path" {
  value = local.board_file
}
