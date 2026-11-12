# Walkthrough: Fossil Pit Wiring

1. **Validate.** `terraform validate` prints a warning and an error:
   ```
   Warning: Quoted references are deprecated
     on main.tf line 18, in resource "random_id" "north_tag":
   Error: Provider configuration not present
     ... random_id.south_tag ... provider["registry.terraform.io/hashicorp/random"].south ...
   ```
2. **Read the two provider blocks.** They declare the aliases `north_pit` and `south_pit`. Nothing is
   called `south`.
3. **Fix both lines.**
   ```hcl
   provider = random.north_pit
   provider = random.south_pit
   ```
4. **Apply** and confirm with `terraform state pull | jq '.resources[].provider'`: the two tags
   must show the `.north_pit` and `.south_pit` suffixes. Then type `check`.
