# Cab PIN slips for the Kingsgate building-site tower-crane operators.
# The PINs are secrets; the operators' names are not.

resource "local_sensitive_file" "pin_slip" {
  for_each = var.pins
  filename = "${path.module}/slips/${each.key}.pin"
  content  = each.value
}

output "slip_count" {
  value = length(local_sensitive_file.pin_slip)
}
