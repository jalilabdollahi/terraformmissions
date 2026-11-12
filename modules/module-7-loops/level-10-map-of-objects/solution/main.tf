# Pickup slips for the Millbrook food bank.
# Each pickup slot has a volunteer, a number of boxes and a time.

resource "local_file" "pickup_slip" {
  for_each = var.slots
  filename = "${path.module}/slips/${each.key}.txt"
  content  = "Slot ${each.key}: ${each.value.volunteer} collects ${each.value.boxes} boxes at ${each.value.time}\n"
}

output "total_boxes" {
  value = sum([for s in var.slots : s.boxes])
}
