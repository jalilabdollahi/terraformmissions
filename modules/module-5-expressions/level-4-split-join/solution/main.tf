locals {
  raw      = "a;b;c"
  parts    = split(";", local.raw)
  rejoined = join("-", local.parts)
}

output "result" {
  value = local.rejoined
}
