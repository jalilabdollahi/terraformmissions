# Thistledown quilting bee - the noticeboard in the church hall.

locals {
  board_file = "${path.module}/board/notices.md"

  intro = "# Quilting Bee notices\nMeets Thursdays at 7 in the church hall.\n"
  events = [
    "14 Nov: charity quilt raffle",
    "28 Nov: batting swap",
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
