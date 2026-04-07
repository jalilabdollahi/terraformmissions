resource "random_string" "token_alpha" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_beta" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "token_gamma" {
  length  = 8
  special = false
  upper   = false
}

output "token_results" {
  value = [
    random_string.token_alpha.result,
    random_string.token_beta.result,
    random_string.token_gamma.result,
  ]
}
