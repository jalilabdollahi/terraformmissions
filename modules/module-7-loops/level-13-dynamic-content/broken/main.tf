variable "tags" {
  type = map(string)
  default = {
    env  = "prod"
    team = "platform"
  }
}

# The dynamic block iterator is named 'tag' (from the block label).
# Inside content, use tag.key and tag.value — NOT each.value.name.
locals {
  tags_content = join("\n", [
    for k, v in var.tags : "${k}=${v}"
  ])
}

resource "local_file" "tags_file" {
  # Wrong iterator references — each.value.name and each.value.value don't exist here
  content  = join("\n", [for k, v in var.tags : "${each.value.name}=${each.value.value}"])
  filename = "${path.module}/tags.txt"
}
