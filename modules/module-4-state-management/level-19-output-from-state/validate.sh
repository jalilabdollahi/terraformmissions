#!/usr/bin/env bash
set -euo pipefail

# Create a minimal "other" state file for the remote_state data source to read
cat > "$(pwd)/other.tfstate" << 'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
  "outputs": {
    "greeting": {
      "value": "hello from other state",
      "type": "string"
    }
  },
  "resources": []
}
STATEOF

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: plan succeeded — remote state path is correct"
    exit 0
fi

if grep -qE "No such file|does not exist|nonexistent" /tmp/plan_out.txt 2>/dev/null; then
    echo "❌ FAIL: remote state file not found — fix the path"
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: plan failed (exit $PLAN_EXIT)"
fi
exit 1
