# Bug: tomap() expects a map or object, not a list.
# tolist(tomap(["a","b","c"])) is a double type error:
# 1. tomap(["a","b","c"]) fails — can't make a map from a plain list
# 2. Even if it worked, tolist(map) would then fail

locals {
  items = tolist(tomap(["a", "b", "c"]))
}

resource "local_file" "type_test" {
  content  = join(", ", local.items)
  filename = "${path.module}/items.txt"
}
