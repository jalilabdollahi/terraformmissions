locals {
  app_label = format("%s-%d", "app", 1)
}

output "app_label" {
  value = local.app_label
}
