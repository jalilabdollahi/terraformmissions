# Granite Gate Mall — shopper Wi-Fi captive portal settings.
# The concierge-desk automation reads `portal_login_url` to open the admin page.

locals {
  portal_host = "portal.granite-gate.example"
}

resource "local_sensitive_file" "portal_env" {
  filename = "${path.module}/portal/portal.env"
  content  = "ADMIN_USER=concierge\nADMIN_PASSWORD=${var.portal_admin_password}\nHOST=${local.portal_host}\n"
}

output "portal_login_url" {
  description = "Admin login URL with credentials for the concierge-desk tool."
  value       = "https://concierge:${var.portal_admin_password}@${local.portal_host}/admin"
}

output "mall" {
  value = var.mall_name
}
