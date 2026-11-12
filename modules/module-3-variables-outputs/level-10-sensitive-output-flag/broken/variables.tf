variable "mall_name" {
  type    = string
  default = "Granite Gate Mall"
}

variable "portal_admin_password" {
  description = "Password of the shopper Wi-Fi captive-portal admin account."
  type        = string
  sensitive   = true
}
