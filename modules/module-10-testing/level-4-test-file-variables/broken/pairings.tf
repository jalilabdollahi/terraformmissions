variable "club" {
  description = "Club name printed on the pairing sheet."
  type        = string
}

variable "players" {
  description = "Registered players for the evening."
  type        = list(string)
}

locals {
  boards = ceil(length(var.players) / 2)
  byes   = length(var.players) % 2
}

output "boards" {
  value = local.boards
}

output "byes" {
  value = local.byes
}

output "sheet_title" {
  value = "${var.club}: ${local.boards} boards"
}
