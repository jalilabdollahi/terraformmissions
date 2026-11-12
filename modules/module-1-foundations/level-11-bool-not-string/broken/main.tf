# Guest Wi-Fi voucher for the Driftwood Hostel. The label printer can only
# print capital letters and digits, and staff read the code out loud, so
# no symbols and no lowercase.
resource "random_string" "wifi_voucher" {
  length  = 8
  upper   = "yes"
  lower   = "disabled"
  numeric = "enabled"
  special = "no"
}

resource "local_file" "voucher_slip" {
  filename = "${path.module}/hostel/voucher-slip.txt"
  content  = "Driftwood Hostel guest Wi-Fi\nVoucher: ${random_string.wifi_voucher.result}\n"
}

output "voucher" {
  value = random_string.wifi_voucher.result
}
