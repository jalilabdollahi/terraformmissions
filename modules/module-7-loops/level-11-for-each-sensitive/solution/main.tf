# Cab PIN slips for the Kingsgate building-site tower-crane operators.
# The PINs are secrets; the operators' names are not.

resource "local_sensitive_file" "pin_slip" {
  # The names are not secret even though the map holding the PINs is.
  for_each = nonsensitive(toset(keys(var.pins)))
  filename = "${path.module}/slips/${each.key}.pin"
  content  = var.pins[each.key]
}

output "slip_count" {
  value = length(local_sensitive_file.pin_slip)
}
