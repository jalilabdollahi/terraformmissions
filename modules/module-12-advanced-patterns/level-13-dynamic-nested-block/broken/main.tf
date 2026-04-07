locals {
  environments = {
    prod = ["us-east-1", "eu-west-1"]
    dev  = ["us-east-1"]
  }
}

# Bug: nested for expressions work fine, but a nested dynamic block pattern
# with identical iterators causes the outer iterator to be inaccessible.
# The correct fix is to use explicit 'iterator' labels on nested dynamic blocks.
#
# Simulated here: the locals below produce wrong output because the inner loop
# incorrectly re-uses the variable name 'env' causing a shadowing bug in complex expressions.

locals {
  # Wrong: tries to use 'env' in both outer and inner scope — inner shadows outer
  bad_pairs = flatten([
    for env in keys(local.environments) : [
      for env in local.environments[env] : "${env}:${env}"
    ]
  ])

  # Correct: rename inner iterator to avoid shadowing
  good_pairs = flatten([
    for env_name in keys(local.environments) : [
      for region in local.environments[env_name] : "${env_name}:${region}"
    ]
  ])
}

resource "local_file" "region_map" {
  content  = join("\n", local.good_pairs)
  filename = "${path.module}/regions.txt"
}

output "pair_count" {
  value = length(local.good_pairs)
}
