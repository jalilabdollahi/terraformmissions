#!/usr/bin/env bash
set -euo pipefail

# terraform init must succeed (meaning the version constraint is satisfiable)
if terraform init -no-color -input=false 2>&1; then
    echo "PASS: terraform init succeeded with valid provider version constraint"
    exit 0
fi
echo "FAIL: terraform init failed — version constraint may reference a non-existent version"
exit 1
