# This is a deliberately broken .terraform.lock.hcl with wrong hashes.
# Terraform init will fail because the hashes don't match the actual provider.
provider "registry.terraform.io/hashicorp/random" {
  version     = "3.6.0"
  constraints = "~> 3.6"
  hashes = [
    "h1:FAKEHASHFAKEHASHFAKEHASHFAKEHASHFAKEHASH=",
    "zh:0000000000000000000000000000000000000000000000000000000000000000",
  ]
}
