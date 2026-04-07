# BUG: formatlist with two placeholders but only one list argument.
# formatlist requires a list for each placeholder.

locals {
  labels = formatlist("%s-%s", ["a", "b"])
}

output "labels" {
  value = local.labels
}
