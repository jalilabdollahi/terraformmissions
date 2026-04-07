variable "replica_count" {
  type    = number
  default = 42
}

output "replica_count" {
  value = var.replica_count
}
