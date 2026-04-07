resource "random_string" "token" {
  length  = "16"   # Wrong: should be a number, not a string
  special = false
}

output "token" {
  value = random_string.token.result
}
