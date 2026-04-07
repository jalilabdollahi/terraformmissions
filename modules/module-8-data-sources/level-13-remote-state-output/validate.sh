#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create fake remote state with vpc_id output
cat > "${SCRIPT_DIR}/vpc.tfstate" <<'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "fake-lineage-vpc",
  "outputs": {
    "vpc_id": {
      "value": "vpc-abcdef01",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}
STATEOF

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded accessing correct output key"
    rm -f "${SCRIPT_DIR}/vpc.tfstate"
    exit 0
fi

cat /tmp/tf_out.txt
rm -f "${SCRIPT_DIR}/vpc.tfstate"
echo "❌ FAIL: terraform plan failed"
exit 1
