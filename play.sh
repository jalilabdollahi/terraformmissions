#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional: --reset flag wipes progress
if [[ "${1:-}" == "--reset" ]]; then
  rm -f "$REPO_ROOT/progress.json"
  echo "Progress reset."
fi

# Activate venv
if [[ ! -d "$REPO_ROOT/venv" ]]; then
  echo "Run ./install.sh first."
  exit 1
fi

source "$REPO_ROOT/venv/bin/activate"

# Install jq if missing (macOS)
if ! command -v jq &>/dev/null; then
  if command -v brew &>/dev/null; then
    brew install jq
  elif command -v apt-get &>/dev/null; then
    echo "jq is required."
    echo "Install it with: sudo apt-get update && sudo apt-get install -y jq"
    exit 1
  else
    echo "jq is required. Install it and re-run."
    exit 1
  fi
fi

export PYTHONPATH="$REPO_ROOT"
exec python3 -m engine.engine
