# Harbor Inn — guest Wi-Fi captive portal settings.
# The front-desk automation reads `portal_login_url` to open the admin page.

locals {
  portal_host = "portal.harbor-inn.example"
}

resource "local_sensitive_file" "portal_env" {
  filename = "${path.module}/portal/portal.env"
  content  = "ADMIN_USER=desk\nADMIN_PASSWORD=${var.portal_admin_password}\nHOST=${local.portal_host}\n"
}

output "portal_login_url" {
  description = "Admin login URL with credentials for the front-desk tool."
  sensitive   = true
  value       = "https://desk:${var.portal_admin_password}@${local.portal_host}/admin"
}

output "inn" {
  value = var.inn_name
}
