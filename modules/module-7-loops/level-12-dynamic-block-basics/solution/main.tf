variable "config_pairs" {
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    { key = "color", value = "blue" },
    { key = "size",  value = "large" },
  ]
}

locals {
  config_content = join("\n", [
    for pair in var.config_pairs : "${pair.key}=${pair.value}"
  ])
}

resource "local_file" "config" {
  content  = local.config_content
  filename = "${path.module}/config.txt"
}

resource "null_resource" "demo" {
  triggers = {
    for pair in var.config_pairs : pair.key => pair.value
  }
}
