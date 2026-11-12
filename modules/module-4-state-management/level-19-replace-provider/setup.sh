#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_record tag "$(tm_state_attr random_id.crate_tag hex)"
tm_record pallets "$(tm_state_attr random_integer.pallet_count result)"
# Rewrite the state the way Terraform 0.12 would have recorded the provider.
python3 - <<'PY'
import json
s = json.load(open("terraform.tfstate"))
for r in s["resources"]:
    r["provider"] = r["provider"].replace("registry.terraform.io/hashicorp/random", "registry.terraform.io/-/random")
json.dump(s, open("terraform.tfstate", "w"), indent=2)
PY
