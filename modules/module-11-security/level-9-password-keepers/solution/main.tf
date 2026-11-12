# Combination for the rigging locker in the Fiddlestick & Sons big top.
# Riggers rotate it by raising a ticket number, never by accident.
variable "rotation_ticket" {
  type        = string
  description = "bump this (e.g. RIG-101) to rotate the locker combination"
  default     = "RIG-100"
}

resource "random_password" "locker" {
  length  = 12
  special = false
  upper   = false

  keepers = {
    ticket = var.rotation_ticket
  }
}

resource "local_sensitive_file" "locker_code" {
  filename        = "${path.module}/rigging/locker-code.txt"
  content         = "${random_password.locker.result}\n"
  file_permission = "0600"
}

output "rotation_ticket_in_force" {
  value = var.rotation_ticket
}
