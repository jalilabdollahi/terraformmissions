resource "random_string" "ci_token" {
  length  = 16
  special = false
}

output "ci_token" {
  value = random_string.ci_token.result
}
