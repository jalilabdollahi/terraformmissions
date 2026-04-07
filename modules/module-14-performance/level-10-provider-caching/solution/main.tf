resource "random_string" "cached" {
  length  = 8
  special = false
}

output "result" {
  value = random_string.cached.result
}
