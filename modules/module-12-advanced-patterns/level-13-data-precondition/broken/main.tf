# Baseline Squash Club: the monthly court ladder is read from a CSV export.
# Two guards were meant to protect the read:
#   - before reading: the file must exist and must be a .csv
#   - after reading: its first line must be the header "rank,player,rating"
# Right now both rules are crammed into one precondition and Terraform will not load it.

variable "ladder_file" {
  type    = string
  default = "data/ladder.csv"
}

data "local_file" "ladder" {
  filename = "${path.module}/${var.ladder_file}"

  lifecycle {
    precondition {
      condition     = startswith(data.local_file.ladder.content, "rank,player,rating")
      error_message = "The ladder export must start with the header rank,player,rating."
    }
  }
}

locals {
  rows     = csvdecode(data.local_file.ladder.content)
  champion = [for r in local.rows : r.player if r.rank == "1"][0]
}

resource "local_file" "standings" {
  filename = "${path.module}/club/standings.txt"
  content  = "champion: ${local.champion}\nplayers: ${length(local.rows)}\n"
}

output "champion" {
  value = local.champion
}
