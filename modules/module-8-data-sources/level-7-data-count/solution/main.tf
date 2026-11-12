# Sheet music publisher: each piece's score is a small text file; the contents page is built from all of them.

variable "scores" {
  type    = list(string)
  default = ["p01", "p02", "p03"]
}

data "local_file" "score" {
  count    = length(var.scores)
  filename = "${path.module}/scores/${var.scores[count.index]}.txt"
}

locals {
  titles = [for g in data.local_file.score : trimspace(regex("title: (.*)", g.content)[0])]
  notes  = [for g in data.local_file.score : tonumber(regex("notes: ([0-9]+)", g.content)[0])]
}

resource "local_file" "contents_page" {
  filename = "${path.module}/folio/contents.txt"
  content = join("\n", concat(
    [for i, t in local.titles : "${i + 1}. ${t} - ${local.notes[i]} notes"],
    ["Total: ${sum(local.notes)} notes", ""]
  ))
}

output "total_notes" {
  value = sum(local.notes)
}

output "piece_titles" {
  value = local.titles
}
