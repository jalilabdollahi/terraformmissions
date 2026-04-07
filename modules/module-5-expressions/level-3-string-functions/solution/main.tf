variable "name" {
  type    = string
  default = "Hello World 123"
}

locals {
  cleaned = replace(var.name, "/[^a-z]/", "-")
}

output "cleaned" {
  value = local.cleaned
}
