variable "tags" {
  type = map(string)
  default = {
    env  = "prod"
    team = "platform"
  }
}

locals {
  tags_content = join("\n", [
    for k, v in var.tags : "${k}=${v}"
  ])
}

resource "local_file" "tags_file" {
  content  = local.tags_content
  filename = "${path.module}/tags.txt"
}
