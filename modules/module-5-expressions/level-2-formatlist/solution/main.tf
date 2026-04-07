locals {
  labels = formatlist("%s", ["a", "b"])
}

output "labels" {
  value = local.labels
}
