# Caerwen Choral Society — who sings, who rehearsed, who needs a robe.
# The sign-up sheets are typed by hand, so names repeat and come in any order.

variable "concert_singers" {
  type    = list(string)
  default = ["Rhys", "Anwen", "Dilys", "Rhys", "Gethin", "Bryn"]
}

variable "rehearsal_singers" {
  type    = list(string)
  default = ["Bryn", "Cerys", "Anwen", "Gethin", "Bryn"]
}

variable "robe_owners" {
  type    = list(string)
  default = ["Dilys", "Gethin", "Elin"]
}

locals {
  everyone    = concat(var.concert_singers, var.rehearsal_singers)
  regulars    = setunion(var.concert_singers, var.rehearsal_singers)
  need_a_robe = setsubtract(var.robe_owners, var.concert_singers)
}

resource "local_file" "robe_list" {
  filename = "${path.module}/lists/robes.txt"
  content  = "${join("\n", sort(tolist(local.need_a_robe)))}\n"
}

output "everyone" {
  value = local.everyone
}

output "regulars" {
  value = local.regulars
}

output "need_a_robe" {
  value = local.need_a_robe
}
