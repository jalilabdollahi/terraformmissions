# Merged config: contains resources from both alpha and beta.
# Missing: moved blocks to bring beta resources in from beta's state.
# Without them, Terraform plans to create beta_token fresh (ignoring beta's state).

resource "random_string" "alpha_token" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "beta_token" {
  length  = 10
  special = false
  upper   = false
}

output "alpha_token_id" { value = random_string.alpha_token.result }
output "beta_token_id"  { value = random_string.beta_token.result }
