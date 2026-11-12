terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

# A session token that exists only while Terraform runs.
ephemeral "random_password" "session" {
  length  = 40
  special = false
}

output "session_token" {
  description = "one-shot token for the taxi hand-off"
  value       = ephemeral.random_password.session.result
}
