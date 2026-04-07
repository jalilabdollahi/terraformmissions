#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check resource type)"
    exit 1
fi

if ! terraform state rm local_file.config > /tmp/rm_out.txt 2>&1; then
    cat /tmp/rm_out.txt
    echo "❌ FAIL: terraform state rm failed"
    exit 1
fi

if terraform state show 'local_file.config' > /dev/null 2>&1; then
    echo "❌ FAIL: local_file.config still in state after rm"
    exit 1
fi

echo "✅ PASS: apply succeeded and state rm removed the resource"
exit 0
