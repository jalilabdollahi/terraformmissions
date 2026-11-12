# Visitor Wi-Fi vouchers for the Cobalt Yard coworking reception.
# Policy from the router vendor: 12 characters, with some of every class so
# the captive portal accepts it.

resource "random_password" "visitor_wifi" {
  length      = 12
  min_upper   = 3
  min_lower   = 3
  min_numeric = 3
  min_special = 2
}

resource "local_sensitive_file" "voucher" {
  filename = "${path.module}/reception/wifi-voucher.txt"
  content  = "Cobalt Yard visitor Wi-Fi\nPassword: ${random_password.visitor_wifi.result}\n"
}

output "visitor_wifi_password" {
  value     = random_password.visitor_wifi.result
  sensitive = true
}
