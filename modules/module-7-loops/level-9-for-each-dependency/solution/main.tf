variable "labels" {
  type    = set(string)
  default = ["alpha", "beta"]
}

resource "local_file" "configs" {
  for_each = var.labels
  content  = "config: ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

resource "local_file" "summaries" {
  for_each = { for k, v in local_file.configs : k => v.filename }
  content  = "summary for ${each.key}: ${each.value}"
  filename = "${path.module}/summary-${each.key}.txt"
}
