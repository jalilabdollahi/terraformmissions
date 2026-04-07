variable "labels" {
  type    = set(string)
  default = ["alpha", "beta"]
}

resource "local_file" "configs" {
  for_each = var.labels
  content  = "config: ${each.key}"
  filename = "${path.module}/config-${each.key}.txt"
}

# Wrong: can't use a resource object directly as for_each
resource "local_file" "summaries" {
  for_each = local_file.configs
  content  = "summary for ${each.key}: ${each.value.filename}"
  filename = "${path.module}/summary-${each.key}.txt"
}
