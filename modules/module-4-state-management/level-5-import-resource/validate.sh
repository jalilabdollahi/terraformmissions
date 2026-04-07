#!/usr/bin/env bash
set -euo pipefail

# Create the "pre-existing" file that simulates an out-of-band resource
printf 'pre-existing file content' > /tmp/tm_existing.txt

if ! terraform init -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init failed"
    exit 1
fi

if ! terraform import local_file.existing /tmp/tm_existing.txt > /tmp/import_out.txt 2>&1; then
    cat /tmp/import_out.txt
    echo "❌ FAIL: terraform import failed"
    exit 1
fi

if terraform state show 'local_file.existing' > /dev/null 2>&1; then
    echo "✅ PASS: local_file.existing imported and visible in state"
    exit 0
fi
echo "❌ FAIL: local_file.existing not found in state after import"
exit 1
