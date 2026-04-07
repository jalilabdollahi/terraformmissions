# BUG: default = "42" is a string, not a number. The type is declared as number.

variable "replica_count" {
  type    = number
  default = "42"
}

output "replica_count" {
  value = var.replica_count
}
