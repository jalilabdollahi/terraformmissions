# Marlowe Street Library — featured shelf.
# The front window shows one featured genre per month: the one that comes
# first in the alphabet among the genres on the donation list.

variable "branch" {
  type    = string
  default = "Marlowe Street Branch"
}

variable "donated_genres" {
  description = "Genres in this month's donation boxes (no duplicates, no order)."
  type        = set(string)
  default     = ["poetry", "astronomy", "cookery", "mystery"]
}

locals {
  featured = sort(tolist(var.donated_genres))[0]
}

resource "local_file" "window_card" {
  filename = "${path.module}/window/featured.txt"
  content  = "${var.branch} - featured this month: ${local.featured}\n"
}

output "featured_genre" {
  value = local.featured
}

output "genre_count" {
  value = length(var.donated_genres)
}
