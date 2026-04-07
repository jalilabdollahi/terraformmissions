#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

if ! terraform state mv local_file.old_name local_file.new_name > /tmp/mv_out.txt 2>&1; then
    cat /tmp/mv_out.txt
    echo "❌ FAIL: terraform state mv failed"
    exit 1
fi

if terraform state show 'local_file.new_name' > /dev/null 2>&1; then
    echo "✅ PASS: local_file.new_name exists in state after mv"
    exit 0
fi
echo "❌ FAIL: local_file.new_name not found after state mv"
exit 1
