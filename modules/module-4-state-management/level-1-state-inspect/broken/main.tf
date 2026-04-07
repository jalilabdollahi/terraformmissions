# Three random_string resources: alpha, beta, gamma
# The output mistakenly references a nonexistent resource "delta".

resource "random_string" "alpha" {
  length  = 8
  special = false
}

resource "random_string" "beta" {
  length  = 8
  special = false
}

resource "random_string" "gamma" {
  length  = 8
  special = false
}

# BUG: random_string.delta does not exist
output "last_string" {
  value = random_string.delta.result
}
