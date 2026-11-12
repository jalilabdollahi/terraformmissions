# Walkthrough - Willow Wren Version Clash

1. `terraform init` fails with `no available releases match the given constraints >= 3.5, ~> 2.3, ~> 3.6`. The error lists
   *all* constraints Terraform collected for that provider - from the root and from every module.
2. Find where they come from:
   ```bash
   grep -rn "hashicorp/random" -A2 --include=*.tf .
   ```
   - root `terraform.tf`: `~> 3.6`
   - `modules/berths/versions.tf`: `>= 3.5`
   - `modules/galley/versions.tf`: `~> 2.3`
3. Intersect them. `~> 3.6` means `>= 3.6, < 4.0`; `~> 2.3` means `>= 2.3, < 3.0`. Nothing satisfies both.
4. The galley module only uses `random_integer`, which exists unchanged in 3.x. Loosen its constraint to `>= 2.3, < 4.0`
   (it is the odd one out, copied from an old repo).
5. `terraform init`, `terraform apply`, `check`.
