#!/usr/bin/env bash
# Plan gate for the bonded warehouse. See policy/RULES.txt.
plan="${1:-}"

# R4: fail closed
if [[ -z "$plan" || ! -r "$plan" ]]; then
  echo "usage: policy/check.sh plan.json (file missing or unreadable)" >&2
  exit 2
fi
if ! jq -e . "$plan" >/dev/null 2>&1; then
  echo "plan file is not valid JSON" >&2
  exit 2
fi

violations=$(jq -r '
  (.resource_changes // [])[]
  | . as $rc
  | ($rc.change.actions // []) as $a
  | (
      # R1: anything that deletes or replaces
      (if ($a | index("delete")) != null then "VIOLATION: \($rc.address): deletes or replaces an existing object" else empty end),
      # R2 + R3: only for local_file being created or updated
      (if $rc.type == "local_file" and (($a | index("create")) != null or ($a | index("update")) != null) then
         (($rc.change.after.file_permission // "") as $p
          | if ($p | test("^0[0-7]{2}0$")) then empty
            else "VIOLATION: \($rc.address): file_permission \($p | tojson) gives access to others" end),
         (($rc.change.after.filename // "") as $f
          | if ($f | test("^(\\./)?bonded/")) and (($f | contains("..")) | not) then empty
            else "VIOLATION: \($rc.address): filename \($f | tojson) is outside bonded/" end)
       else empty end)
    )' "$plan") || exit 2

if [[ -n "$violations" ]]; then
  echo "$violations"
  exit 1
fi
exit 0
