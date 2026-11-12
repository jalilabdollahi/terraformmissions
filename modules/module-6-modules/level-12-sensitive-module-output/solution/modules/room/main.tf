variable "digits" {
  type = number
}

resource "random_password" "door" {
  length  = var.digits
  upper   = false
  lower   = false
  special = false
}

output "code" {
  value     = random_password.door.result
  sensitive = true
}
