#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a fake local state file that the data source will read
cat > "${SCRIPT_DIR}/network.tfstate" <<'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "fake-lineage-for-test",
  "outputs": {
    "vpc_id": {
      "value": "vpc-12345678",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}
STATEOF

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded with remote state"
    rm -f "${SCRIPT_DIR}/network.tfstate"
    exit 0
fi

cat /tmp/tf_out.txt
rm -f "${SCRIPT_DIR}/network.tfstate"
echo "❌ FAIL: terraform plan failed"
exit 1
