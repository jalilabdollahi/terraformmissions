# INCIDENT: Provider was upgraded. The new config uses 'char_count' which does not
# exist on random_string. The correct attribute name is 'length'.
# This simulates a breaking change where an attribute was renamed between provider versions.
resource "random_string" "rotated_secret" {
  char_count = 20
  special    = true
  upper      = true
}

resource "random_string" "rotated_token" {
  char_count = 16
  special    = false
  upper      = false
}

output "secret_result" { value = random_string.rotated_secret.result }
output "token_result"  { value = random_string.rotated_token.result }
