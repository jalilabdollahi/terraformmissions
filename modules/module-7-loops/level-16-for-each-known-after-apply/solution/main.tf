resource "random_string" "id" {
  length  = 8
  special = false
}

# Use a static key — values (content/filename) can still use random_string.id.result
resource "local_file" "config" {
  for_each = toset(["main"])
  content  = "config for ${random_string.id.result}"
  filename = "${path.module}/config-${each.key}.txt"
}
