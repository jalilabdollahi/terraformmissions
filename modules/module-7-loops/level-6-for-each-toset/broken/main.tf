# Price tags for the Lacegate antiques centre.
# One tag per stall; the stalls are keyed by the dealer who runs them.

resource "local_file" "stall_tag" {
  for_each = var.dealers
  filename = "${path.module}/tags/${each.value}.txt"
  content  = "${upper(each.value)} - 45.00 per week\n"
}

output "tag_count" {
  value = length(local_file.stall_tag)
}
