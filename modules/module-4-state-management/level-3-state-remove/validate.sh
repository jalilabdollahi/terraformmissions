#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check for circular dependency)"
    exit 1
fi

if ! terraform state rm local_file.file_b > /tmp/rm_out.txt 2>&1; then
    cat /tmp/rm_out.txt
    echo "❌ FAIL: terraform state rm failed"
    exit 1
fi

if terraform state show 'local_file.file_b' > /dev/null 2>&1; then
    echo "❌ FAIL: local_file.file_b should have been removed from state"
    exit 1
fi

if terraform state show 'local_file.file_a' > /dev/null 2>&1; then
    echo "✅ PASS: apply succeeded, state rm worked, file_a still tracked"
    exit 0
fi
echo "❌ FAIL: local_file.file_a missing from state"
exit 1
