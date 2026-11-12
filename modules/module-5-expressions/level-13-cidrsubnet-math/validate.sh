#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'cidrsubnet[[:space:]]*\(' "zone blocks must be carved with cidrsubnet()"

tm_apply
tm_assert_output_jq zone_cidrs '. == {"gatehouse":"10.77.0.0/26","offices":"10.77.0.64/26","canteen":"10.77.0.128/26","unit-a":"10.77.0.192/26","unit-b":"10.77.1.0/26","depot":"10.77.1.64/26"}' \
  "with base 10.77.0.0/22 and prefix 26 the six zones should be consecutive /26 blocks starting at 10.77.0.0/26"
tm_assert_output hosts_per_zone 62
tm_assert_file_contains plan/addresses.txt "depot 10.77.1.64/26"

# The size comes from var.subnet_prefix and the range from var.base_cidr, for any number of zones.
tm_plan_json -var base_cidr=192.168.8.0/21 -var subnet_prefix=24 \
  -var 'zones=["a","b","c","d","e","f","g","h"]'
jq -e '.planned_values.outputs.hosts_per_zone.value == 254
  and (.planned_values.outputs.zone_cidrs.value | length == 8)
  and .planned_values.outputs.zone_cidrs.value.a == "192.168.8.0/24"
  and .planned_values.outputs.zone_cidrs.value.h == "192.168.15.0/24"' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "base 192.168.8.0/21 with prefix 24 and eight zones should give /24 blocks from 192.168.8.0/24 to 192.168.15.0/24"

# The default plan really is a non-overlapping layout inside the base range.
python3 - "$(terraform output -json zone_cidrs)" <<'PY' || tm_fail "the zone blocks overlap or leave the base range"
import ipaddress, json, sys
nets = [ipaddress.ip_network(v) for v in json.loads(sys.argv[1]).values()]
base = ipaddress.ip_network("10.77.0.0/22")
assert all(n.subnet_of(base) for n in nets)
assert not any(a.overlaps(b) for i, a in enumerate(nets) for b in nets[i + 1:])
PY
tm_pass "zone blocks are derived from the base range and prefix and never overflow"
