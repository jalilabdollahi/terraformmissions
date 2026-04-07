locals {
  # BUG: the string uses semicolons but split uses a comma separator
  raw   = "a;b;c"
  parts = split(",", local.raw)
  rejoined = join("-", local.parts)
}

output "result" {
  value = local.rejoined
}
