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

output "last_string" {
  value = random_string.gamma.result
}
