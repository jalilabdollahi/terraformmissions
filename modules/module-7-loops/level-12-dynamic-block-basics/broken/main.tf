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

# local_sensitive_file accepts a single content argument — we use local_file
# and simulate nested blocks with a locals workaround.
# The broken part: dynamic block name is "setting" but must be "settings".
locals {
  config_content = join("\n", [
    for pair in var.config_pairs : "${pair.key}=${pair.value}"
  ])
}

resource "local_file" "config" {
  content  = local.config_content
  filename = "${path.module}/config.txt"
}

# For illustration: a null_resource with dynamic provisioner blocks
resource "null_resource" "demo" {
  # Wrong: block name is "setting" — should match the label used inside
  dynamic "setting" {
    for_each = var.config_pairs
    content {
      # triggers uses the setting iterator
    }
  }
}
