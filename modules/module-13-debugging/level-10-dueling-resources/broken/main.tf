# Thistledown quilting bee - the noticeboard in the church hall.

locals {
  board_file = "${path.module}/board/notices.md"

  intro = "# Quilting Bee notices\nMeets Thursdays at 7 in the church hall.\n"
  events = [
    "14 Nov: charity quilt raffle",
    "28 Nov: batting swap",
  ]
}

# Owned by the chair: the standing text.
resource "local_file" "board_intro" {
  filename = local.board_file
  content  = local.intro
}

# Owned by the events secretary: the dated list.
resource "local_file" "board_events" {
  filename = local.board_file
  content  = "\n## Events\n${join("\n", [for e in local.events : "- ${e}"])}\n"
}

output "board_path" {
  value = local.board_file
}
