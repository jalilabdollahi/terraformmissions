#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== TerraformMissions — Setup ==="

detect_os() {
  case "$(uname -s)" in
    Linux)  echo "linux" ;;
    Darwin) echo "macos" ;;
    *)      echo "other" ;;
  esac
}

OS_NAME="$(detect_os)"

terraform_manual_help() {
  cat <<'EOF'
Install Terraform, then re-run this script.
Ubuntu/Debian example:
  sudo apt-get update && sudo apt-get install -y wget gpg software-properties-common
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install -y terraform
EOF
}

install_terraform_linux() {
  if ! command -v apt-get &>/dev/null; then
    return 1
  fi

  if ! command -v sudo &>/dev/null; then
    echo "sudo is required for automatic Terraform installation."
    return 1
  fi

  if [[ ! -r /etc/os-release ]]; then
    echo "Unable to detect Linux distribution from /etc/os-release."
    return 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release

  if [[ -z "${VERSION_CODENAME:-}" ]]; then
    echo "Unable to determine Ubuntu/Debian codename."
    return 1
  fi

  echo "Terraform not found. Attempting automatic install for Ubuntu/Debian..."
  sudo apt-get update
  sudo apt-get install -y wget gpg software-properties-common
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y terraform
}

missing_cmd_help() {
  local cmd="$1"

  case "$cmd" in
    terraform)
      case "$OS_NAME" in
        linux)
          terraform_manual_help
          ;;
        macos)
          echo "Install with: brew tap hashicorp/tap && brew install hashicorp/tap/terraform"
          ;;
        *)
          echo "Install from: https://developer.hashicorp.com/terraform/downloads"
          ;;
      esac
      ;;
    python3)
      case "$OS_NAME" in
        linux) echo "Install with: sudo apt-get update && sudo apt-get install -y python3 python3-venv python3-pip" ;;
        macos) echo "Install with: brew install python" ;;
        *)     echo "Install from: https://www.python.org/downloads/" ;;
      esac
      ;;
    jq)
      case "$OS_NAME" in
        linux) echo "Install with: sudo apt-get update && sudo apt-get install -y jq" ;;
        macos) echo "Install with: brew install jq" ;;
        *)     echo "Install jq with your system package manager." ;;
      esac
      ;;
    *)
      echo "Install '$cmd' and re-run this script."
      ;;
  esac
}

# ── Prerequisites check ────────────────────────────────────────────────────────
check_cmd() {
  local cmd="$1"

  if [[ "$cmd" == "terraform" ]] && ! command -v terraform &>/dev/null && [[ "$OS_NAME" == "linux" ]]; then
    if install_terraform_linux && command -v terraform &>/dev/null; then
      echo "✅  terraform installed: $(command -v terraform)"
      return 0
    fi

    echo "❌  'terraform' not found."
    terraform_manual_help
    exit 1
  fi

  if ! command -v "$cmd" &>/dev/null; then
    echo "❌  '$cmd' not found."
    missing_cmd_help "$cmd"
    exit 1
  fi
  echo "✅  $cmd found: $(command -v "$cmd")"
}

check_cmd terraform
check_cmd python3
check_cmd jq

# Terraform version check (need >= 1.5)
TF_VERSION=$(terraform version -json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['terraform_version'])" 2>/dev/null || terraform version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
TF_MAJOR=$(echo "$TF_VERSION" | cut -d. -f1)
TF_MINOR=$(echo "$TF_VERSION" | cut -d. -f2)
if [[ "$TF_MAJOR" -lt 1 ]] || { [[ "$TF_MAJOR" -eq 1 ]] && [[ "$TF_MINOR" -lt 5 ]]; }; then
  echo "❌  Terraform >= 1.5 required. Found: $TF_VERSION"
  exit 1
fi
echo "✅  Terraform $TF_VERSION (>= 1.5 required)"

# ── Python venv ────────────────────────────────────────────────────────────────
echo ""
echo "Setting up Python virtual environment..."
if [[ -d "$REPO_ROOT/venv" ]] && [[ ! -x "$REPO_ROOT/venv/bin/python3" ]]; then
  echo "Found an incomplete virtual environment. Rebuilding it..."
  python3 -m venv --clear "$REPO_ROOT/venv"
else
  python3 -m venv "$REPO_ROOT/venv"
fi

if [[ ! -x "$REPO_ROOT/venv/bin/python3" ]]; then
  echo "❌  Virtual environment setup failed: $REPO_ROOT/venv/bin/python3 was not created."
  echo "Try installing the venv support package and re-run:"
  case "$OS_NAME" in
    linux) echo "  sudo apt-get update && sudo apt-get install -y python3-venv" ;;
    macos) echo "  brew install python" ;;
    *)     echo "  Install Python with venv support for your system package manager." ;;
  esac
  exit 1
fi

source "$REPO_ROOT/venv/bin/activate"
python3 -m pip install --quiet --upgrade pip
python3 -m pip install --quiet -r "$REPO_ROOT/requirements.txt"
echo "✅  Python venv ready"

# ── Generate level registry ────────────────────────────────────────────────────
if [[ ! -f "$REPO_ROOT/levels.json" ]]; then
  echo ""
  echo "Building level registry..."
  PYTHONPATH="$REPO_ROOT" python3 "$REPO_ROOT/scripts/generate_registry.py"
  echo "✅  levels.json generated"
fi

# ── Shell completion (optional) ────────────────────────────────────────────────
echo ""
echo "=== Setup Complete ==="
echo ""
echo "  Run the game:  ./play.sh"
echo "  Reset progress:  ./play.sh --reset"
echo ""
echo "Optional — shell completion:"
echo "  zsh:  ln -sf \"\$PWD/completion/_terraformissions\" ~/.oh-my-zsh/completions/_terraformissions"
echo "  bash: source completion/terraformissions.bash"
echo ""
