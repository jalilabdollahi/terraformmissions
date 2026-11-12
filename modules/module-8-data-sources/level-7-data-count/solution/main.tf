# Print shop: each chapter galley is a small text file; the contents page is built from all of them.

variable "galleys" {
  type    = list(string)
  default = ["ch01", "ch02", "ch03"]
}

data "local_file" "galley" {
  count    = length(var.galleys)
  filename = "${path.module}/galleys/${var.galleys[count.index]}.txt"
}

locals {
  titles = [for g in data.local_file.galley : trimspace(regex("title: (.*)", g.content)[0])]
  words  = [for g in data.local_file.galley : tonumber(regex("words: ([0-9]+)", g.content)[0])]
}

resource "local_file" "contents_page" {
  filename = "${path.module}/proofs/contents.txt"
  content = join("\n", concat(
    [for i, t in local.titles : "${i + 1}. ${t} - ${local.words[i]} words"],
    ["Total: ${sum(local.words)} words", ""]
  ))
}

output "total_words" {
  value = sum(local.words)
}

output "chapter_titles" {
  value = local.titles
}
