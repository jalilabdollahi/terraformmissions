resource "local_file" "items" {
  for_each = toset(["primary"])
  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}

# Bug: "primary" key is missing quotes in the moved block
moved {
  from = local_file.items[0]
  to   = local_file.items[primary]
}
