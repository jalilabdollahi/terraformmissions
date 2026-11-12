variable "team" {
  type = string
}

variable "quota_min" {
  type = number
}

variable "quota_max" {
  type = number
}

variable "upstream" {
  type    = string
  default = ""
}

resource "random_id" "batch" {
  byte_length = 5
}

resource "random_integer" "quota" {
  min = var.quota_min
  max = var.quota_max
}

resource "local_file" "ledger" {
  filename = "${path.root}/../../out/${var.team}-ledger.txt"
  content  = "team ${var.team} batch ${random_id.batch.hex} quota ${random_integer.quota.result}${var.upstream == "" ? "" : " upstream ${var.upstream}"}\n"
}

output "batch" {
  value = random_id.batch.hex
}
