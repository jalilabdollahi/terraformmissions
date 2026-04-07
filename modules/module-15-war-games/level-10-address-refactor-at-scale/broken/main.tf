# Refactored resource names:
#   old: svc_one     → new: service_alpha
#   old: svc_two     → new: service_beta
#   old: svc_three   → new: service_gamma
#   old: svc_four    → new: service_delta
#   old: svc_five    → new: service_epsilon
#
# Missing: moved blocks to map old addresses to new ones.
# Without them, Terraform plans to destroy all 5 old + create 5 new.

resource "random_string" "service_alpha" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_beta" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_gamma" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_delta" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_epsilon" {
  length  = 8
  special = false
  upper   = false
}

output "service_ids" {
  value = [
    random_string.service_alpha.result,
    random_string.service_beta.result,
    random_string.service_gamma.result,
    random_string.service_delta.result,
    random_string.service_epsilon.result,
  ]
}
