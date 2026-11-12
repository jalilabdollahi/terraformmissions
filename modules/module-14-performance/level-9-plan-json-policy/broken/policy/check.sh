#!/usr/bin/env bash
# Plan gate for the bonded warehouse. See policy/RULES.txt.
plan="$1"
violations=0

# R1: no deletions
deletes=$(jq '[.resource_changes[] | select(.change.actions == ["delete"])] | length' "$plan" 2>/dev/null)
if [ "$deletes" -gt 0 ]; then
  echo "VIOLATION: plan deletes $deletes object(s)"
  violations=1
fi

# R2: no access for "other"
bad=$(jq -r '.resource_changes[] | select(.type == "local_file") | select((.change.before.file_permission | test("^0[0-7]{2}0$")) | not) | .address' "$plan" 2>/dev/null)
for addr in $bad; do
  echo "VIOLATION: $addr: file_permission gives access to others"
  violations=1
done

exit $violations
