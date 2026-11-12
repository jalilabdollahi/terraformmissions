#!/usr/bin/env bash
# Planning wrapper for the chiller config.
#   ops/plan.sh quick   fast loop while editing code on a laptop
#   ops/plan.sh audit   nightly drift check run by the monitoring cron
cd "$(dirname "$0")/.." || exit 1
mode="${1:-quick}"

case "$mode" in
  quick)
    terraform plan -refresh=false -input=false -detailed-exitcode
    ;;
  audit)
    terraform plan -refresh=false -input=false -detailed-exitcode
    ;;
  *)
    echo "usage: ops/plan.sh quick|audit" >&2
    exit 64
    ;;
esac
