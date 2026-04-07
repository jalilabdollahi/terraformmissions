locals {
  environments = {
    prod = ["us-east-1", "eu-west-1"]
    dev  = ["us-east-1"]
  }
}

locals {
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
