resource "random_string" "token" {
  length  = 12
  special = false
  upper   = false
}

# BUG: random_string does not have an attribute called "id".
# The correct attribute is "result".
output "token_id" {
  value = random_string.token.id
}
