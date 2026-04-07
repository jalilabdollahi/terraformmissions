resource "random_string" "token_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_c" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_d" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_e" {
  length  = 8
  special = false
  upper   = false
}

output "results" {
  value = [
    random_string.token_a.result,
    random_string.token_b.result,
    random_string.token_c.result,
    random_string.token_d.result,
    random_string.token_e.result,
  ]
}
