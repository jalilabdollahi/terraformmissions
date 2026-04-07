# TerraformMissions

![platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue)
![shell](https://img.shields.io/badge/shell-bash-brightgreen)
![terraform](https://img.shields.io/badge/terraform-learning-7B42BC)

> **Learn Terraform by breaking it, then fixing it.**

TerraformMissions is a fully local, game-based Terraform training platform with a rich terminal interface. Each mission drops a deliberately broken Terraform configuration into your workspace. Your job is to diagnose the problem, edit the `.tf` files, and validate the fix using real Terraform commands.

**272 progressive missions across 15 modules, from beginner fundamentals to production war games.**  
No cloud. No AWS bill. No hidden lab costs.

**Design and implementation by: Jalil Abdollahi**  
Email: `jalil.abdollahi@gmail.com`
---

## Features

- **272 missions across 15 modules** covering HCL, state, modules, testing, debugging, performance, and war games
- **Real Terraform workflow** using actual `terraform init`, `validate`, `plan`, `apply`, `output`, and state inspection
- **Rich terminal game loop** with progression, XP, hints, solutions, debriefs, and status tracking
- **Fully local practice** using filesystem-based scenarios and local-safe providers
- **Progressive hints** that help without immediately spoiling the solution
- **Post-level debriefs** that explain why the fix worked and what the real-world takeaway is
- **Watch mode and dry-run mode** for fast feedback while practicing
- **Per-module certificates** rendered directly in the terminal
- **Auto-save progress** after each completed mission
- **Shell completion** for bash and zsh

---

## Quick Start

```bash
git clone https://github.com/jalilabdollahi/terraformmissions.git
cd terraformmissions
./install.sh
./play.sh
```

If `levels.json` is missing or you regenerate modules:

```bash
python3 scripts/generate_registry.py
```

---

## Prerequisites

| Tool | Required | Notes |
|------|----------|-------|
| Terraform `1.5+` | Yes | Main CLI used in every mission |
| Python `3.9+` | Yes | Used for the game engine and setup |
| `jq` | Yes | Used by validators and helper scripts |
| Docker | Optional | Only needed for some advanced Docker-based scenarios |

### Ubuntu / Debian

`install.sh` can guide you through setup. If you want to install manually:

```bash
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip jq wget gpg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
```

### macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install python jq
```

---

## How to Play

1. Run `./play.sh` to launch the game.
2. Read the mission briefing and objective.
3. Open and edit the Terraform files inside `workspace/current/`.
4. Use Terraform normally with commands like `terraform init`, `terraform validate`, and `terraform plan`.
5. Run `check` inside the game when you think the fix is ready.
6. Earn XP, unlock more levels, and keep going.

This project is designed to feel hands-on. You are not reading slides about Terraform. You are repairing broken infrastructure code under realistic conditions.

---

## Commands

| Command | Shortcut | Description |
|---------|----------|-------------|
| `check` | `1` | Validate your solution and award XP if it passes |
| `check-dry` | `d` | Dry-run validation without committing the result |
| `watch` | `w` | Re-run validation every few seconds until the level passes |
| `hint` | `2` | Reveal the next progressive hint |
| `solution` | `3` | Show the reference solution |
| `guide` | `4` | Show a step-by-step walkthrough |
| `debrief` | `5` | Open the learning debrief for the level |
| `plan` | `p` | Run `terraform plan` as a helper action |
| `validate` | `v` | Run `terraform validate` |
| `init` | `i` | Re-run `terraform init` |
| `reset` | `6` | Reset the current level back to its broken state |
| `status` | `7` | Show current progress and XP |
| `skip` | `8` | Skip the current level without earning XP |
| `quit` | `9` | Save and exit |
| `reset-progress` | `0` | Wipe all saved progress |

---

## Learning Path

**15 modules · 272 levels · beginner to expert**

| # | Module | Levels | Difficulty | Topics |
|---|--------|--------|------------|--------|
| 1 | HCL Foundations | 20 | Beginner | Syntax, blocks, file layout, core Terraform flow |
| 2 | Resource Basics | 20 | Beginner | Providers, resources, dependencies, lifecycle basics |
| 3 | Variables and Outputs | 18 | Beginner | Types, validation, defaults, sensitivity |
| 4 | State Management | 20 | Intermediate | State, backends, import, drift, refactoring |
| 5 | Expressions and Functions | 20 | Intermediate | Locals, for-expressions, transforms, built-ins |
| 6 | Modules | 20 | Intermediate | Authoring, consuming, inputs, outputs, versioning |
| 7 | Loops and Conditionals | 18 | Intermediate | `count`, `for_each`, conditionals, dynamic blocks |
| 8 | Data Sources | 15 | Intermediate | Local, external, HTTP, lookup patterns |
| 9 | Workspaces | 12 | Intermediate | Environment isolation and workspace-driven config |
| 10 | Terraform Testing | 18 | Advanced | `terraform test`, assertions, mocks, fixtures |
| 11 | Security and Sensitive Data | 18 | Advanced | Secret handling, policy, safer patterns |
| 12 | Advanced HCL Patterns | 20 | Advanced | Meta-arguments, lifecycle, import and moved blocks |
| 13 | Debugging and Troubleshooting | 18 | Advanced | Error analysis, provider issues, cycle debugging |
| 14 | Performance and Scale | 15 | Expert | Large repos, performance bottlenecks, structure |
| 15 | Production War Games | 20 | Expert | Multi-failure scenarios and recovery thinking |

---

## Why It Is Different

Unlike cloud-based Terraform labs, TerraformMissions is designed for repeatable local practice:

- You fix real `.tf` files instead of filling blanks in a browser
- Levels reset cleanly into a known broken state
- Validators check behavior, not just memorized answers
- The entire experience runs on your machine with no paid cloud account required

That makes it useful both for deliberate practice and for interview preparation.

---

## Project Structure

```text
terraformmissions/
├── play.sh
├── install.sh
├── requirements.txt
├── levels.json
├── engine/
│   ├── engine.py
│   ├── ui.py
│   ├── player.py
│   ├── reset.py
│   └── certificate.py
├── scripts/
│   ├── build_levels.py
│   ├── build_module_01.py
│   ├── ...
│   └── generate_registry.py
├── completion/
│   ├── _terraformissions
│   └── terraformissions.bash
├── workspace/
│   └── current/
└── modules/
    ├── module-1-foundations/
    ├── module-2-resource-basics/
    ├── ...
    └── module-15-production-war-games/
```

Important directories:

- `modules/` contains the source-of-truth mission content
- `workspace/current/` is the active level workspace you edit while playing
- `engine/` contains the terminal UI, progression logic, and reset flow
- `scripts/` contains level builders and registry generators

---

## Shell Completion

### zsh

```bash
ln -sf "$PWD/completion/_terraformissions" ~/.oh-my-zsh/completions/_terraformissions
```

### bash

```bash
source completion/terraformissions.bash
```

---

## Resetting and Progress

- Progress is stored locally in `progress.json`
- The active editable mission files live in `workspace/current/`
- `reset` restores the current level to its original broken state
- `./play.sh --reset` clears saved progress

These local files are ignored by Git in this repo so your personal progress does not need to be committed.

---

## Contributing

Contributions are welcome, especially in these areas:

- New mission ideas
- Validator improvements
- Better hints and debriefs
- UI and usability improvements
- Cross-platform setup polish

If you want to expand the curriculum or improve the engine, open an issue or a pull request.

---

## License

MIT License.
