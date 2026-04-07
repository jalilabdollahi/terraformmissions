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

# moved block: bring beta_token's state from config-beta into this merged config.
# In practice, this is paired with: terraform state mv -state=beta.tfstate -state-out=merged.tfstate ...
moved {
  from = random_string.beta_token
  to   = random_string.beta_token
}

output "alpha_token_id" { value = random_string.alpha_token.result }
output "beta_token_id"  { value = random_string.beta_token.result }
