variable "inn_name" {
  type    = string
  default = "Harbor Inn"
}

variable "portal_admin_password" {
  description = "Password of the guest Wi-Fi captive-portal admin account."
  type        = string
  sensitive   = true
}
