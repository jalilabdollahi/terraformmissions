variable "name" {
  type    = string
  default = "Hello World 123"
}

locals {
  # BUG: replace() takes exactly 3 arguments, not 4
  cleaned = replace(var.name, "/[^a-z]/", "-", "g")
}

output "cleaned" {
  value = local.cleaned
}
