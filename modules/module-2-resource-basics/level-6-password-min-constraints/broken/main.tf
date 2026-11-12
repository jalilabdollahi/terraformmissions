# Guest Wi-Fi vouchers for the Seabreeze Inn front desk.
# Policy from the router vendor: 12 characters, with some of every class so
# the captive portal accepts it.

resource "random_password" "guest_wifi" {
  length      = 12
  min_upper   = 4
  min_lower   = 4
  min_numeric = 3
  min_special = 3
}

resource "local_sensitive_file" "voucher" {
  filename = "${path.module}/frontdesk/wifi-voucher.txt"
  content  = "Seabreeze Inn guest Wi-Fi\nPassword: ${random_password.guest_wifi.result}\n"
}

output "guest_wifi_password" {
  value     = random_password.guest_wifi.result
  sensitive = true
}
