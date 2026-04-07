resource "local_file" "items" {
  for_each = toset(["primary"])
  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}

moved {
  from = local_file.items[0]
  to   = local_file.items["primary"]
}
