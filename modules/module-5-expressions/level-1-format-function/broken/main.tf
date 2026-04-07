# BUG: format() is called with only one argument but the format string
# has two placeholders (%s and %d).

locals {
  app_label = format("%s-%d", "app")
}

output "app_label" {
  value = local.app_label
}
