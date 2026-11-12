# Price tags for the Old Quarter spice market.
# One tag per stall; the stalls are keyed by the spice they sell.

resource "local_file" "stall_tag" {
  for_each = var.spices
  filename = "${path.module}/tags/${each.value}.txt"
  content  = "${upper(each.value)} - 4.50 per 100 g\n"
}

output "tag_count" {
  value = length(local_file.stall_tag)
}
