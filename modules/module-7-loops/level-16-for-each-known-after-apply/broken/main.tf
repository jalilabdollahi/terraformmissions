resource "random_string" "id" {
  length  = 8
  special = false
}

# Wrong: random_string.id.result is unknown at plan time — for_each keys must be known.
resource "local_file" "config" {
  for_each = toset([random_string.id.result])
  content  = "config for ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}
