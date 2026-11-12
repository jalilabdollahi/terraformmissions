# TerraformMissions — Master Plan

> **Learn Terraform by breaking it — then fixing it.**
>
> Design and implementation by: Jalil Abdollahi  
> Email: jalil.abdollahi@gmail.com

---

## Concept

TerraformMissions is a fully local, game-based Terraform training platform.  
Each mission drops a deliberately broken `.tf` configuration in front of you.  
Your job: diagnose and fix it using real `terraform` commands.

**272 progressive missions across 15 modules — beginner to production SRE.**  
No cloud. No AWS. No costs.

---

## How It Differs from k8smissions

| Aspect | k8smissions | TerraformMissions |
|---|---|---|
| Sandbox | `kind` Kubernetes cluster | Local filesystem workspace |
| Broken state | YAML applied to cluster | Broken `.tf` files in workspace/ |
| Fix method | `kubectl` commands | Edit `.tf` files directly |
| Validator | Checks cluster state | Runs `terraform plan`/`apply`/`output` |
| Reset | Delete namespace + re-apply | Restore broken files + `terraform destroy` |
| Prerequisites | Docker, kind, kubectl | Terraform CLI only (+ Docker optional) |

---

## Architecture

### File Structure

```
terraformissions/
├── play.sh                        ← Launch the game
├── install.sh                     ← One-time setup (venv + checks)
├── requirements.txt               ← Python dependencies (rich, pyyaml)
├── levels.json                    ← Pre-built registry (auto-generated)
├── progress.json                  ← Player progress (auto-saved)
├── engine/
│   ├── engine.py                  ← Core game loop
│   ├── ui.py                      ← Rich terminal UI
│   ├── player.py                  ← Player profile
│   ├── reset.py                   ← Level reset / workspace management
│   └── certificate.py             ← Module completion certificates
├── scripts/
│   ├── build_levels.py            ← Auto-generate all level files
│   └── generate_registry.py      ← Build levels.json from modules/
├── completion/
│   ├── _terraformissions          ← zsh completion
│   └── terraformissions.bash      ← bash completion
├── workspace/                     ← Active playing area (managed by engine)
│   └── current/                   ← Current level's .tf files (player edits here)
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tf           ← required_providers + backend config
│       ├── .terraform/
│       ├── .terraform.lock.hcl
│       └── terraform.tfstate
└── modules/
    ├── module-1-foundations/
    │   └── level-1-name/
    │       ├── mission.yaml       ← Level metadata
    │       ├── broken/            ← Broken .tf files (source of truth)
    │       │   ├── main.tf
    │       │   ├── variables.tf
    │       │   └── outputs.tf
    │       ├── solution/          ← Reference solution .tf files
    │       │   ├── main.tf
    │       │   ├── variables.tf
    │       │   └── outputs.tf
    │       ├── validate.sh        ← Validator script (runs in workspace/current/)
    │       ├── hint-1.txt
    │       ├── hint-2.txt
    │       ├── hint-3.txt
    │       ├── debrief.md
    │       └── common-mistakes.md
    └── ...
```

---

### Workspace Management (reset.py)

On every level load or reset:
1. Run `terraform destroy -auto-approve` in `workspace/current/` (best-effort)
2. Delete `workspace/current/` entirely
3. Copy `modules/module-X/level-Y/broken/` → `workspace/current/`
4. Run `terraform init -no-color` in `workspace/current/`
5. Player now edits files in `workspace/current/`

On validator run:
- `validate.sh` receives `WORKSPACE` env var pointing to `workspace/current/`
- Validator runs `terraform` commands inside `workspace/current/`

---

### mission.yaml Structure

```yaml
name: "The Missing Provider"
description: "Terraform init fails — the required_providers block is empty."
objective: "Add the hashicorp/local provider to the required_providers block so terraform init succeeds."
xp: 125
difficulty: "beginner"
expected_time: "5m"
concepts:
  - required_providers
  - terraform block
  - provider versions
module: "module-1-foundations"
level: "level-3-missing-provider"
```

---

### Validation Approach

Validators are bash scripts that run inside `workspace/current/`. They test:

| Technique | Use case |
|---|---|
| `terraform validate` | Syntax + type checking |
| `terraform plan -detailed-exitcode` | Exit 0=no changes, 2=changes needed, 1=error |
| `terraform apply -auto-approve` | Full provisioning |
| `terraform output -json` | Check specific output values |
| `terraform state list` | Check resources exist in state |
| `terraform show -json` | Inspect full state |
| File content checks | Validate `local_file` contents |
| `jq` on state/output | Complex assertions |

---

### Game Commands (engine.py)

| Key | Command | Action |
|---|---|---|
| `1` | `check` | Run validator, award XP if pass |
| `d` | `check-dry` | Dry-run — show if fix would pass, no XP |
| `w` | `watch` | Auto-validate every 5s until pass |
| `2` | `hint` | Reveal next progressive hint |
| `3` | `solution` | Show solution .tf files |
| `4` | `guide` | Step-by-step walkthrough |
| `5` | `debrief` | Post-mission lesson |
| `p` | `plan` | Run `terraform plan` (informational) |
| `v` | `validate` | Run `terraform validate` |
| `i` | `init` | Re-run `terraform init` |
| `6` | `reset` | Restore level to broken state |
| `7` | `status` | Show progress across all modules |
| `8` | `skip` | Skip level (no XP) |
| `9` | `quit` | Save and exit |
| `0` | `reset-progress` | Wipe all progress |

---

### Providers Used (All Local — No Cloud, No Cost)

| Provider | Registry | Use |
|---|---|---|
| `hashicorp/local` | Built-in | File management, data sources |
| `hashicorp/null` | Built-in | Null resources, triggers, provisioners |
| `hashicorp/random` | Built-in | Random strings, integers, passwords, UUIDs |
| `hashicorp/tls` | Built-in | TLS certificates, private keys |
| `hashicorp/http` | Built-in | HTTP data sources |
| `hashicorp/external` | Built-in | External data sources via scripts |
| `kreuzwerker/docker` | Optional | Real container provisioning (advanced modules) |

Docker provider is optional — enabled only in advanced/expert modules when Docker Desktop is running.

---

### Prerequisites

| Tool | Required | Install |
|---|---|---|
| `terraform` (1.10+) | ✅ Yes | `brew install terraform` |
| Python 3.9+ | ✅ Yes | `brew install python@3.11` |
| `jq` | ✅ Yes | `brew install jq` |
| Docker Desktop | ⚪ Optional | For modules 12+ only |

---

## Learning Path — 15 Modules · 272 Levels

| # | Module | Levels | Est. XP | Difficulty | Key Topics |
|---|--------|--------|---------|-----------|------------|
| 1 | 🟢 HCL Foundations | 20 | 2,500 | Beginner | Syntax, blocks, types, file layout |
| 2 | 🟢 Resource Basics | 20 | 2,700 | Beginner | local/null/random/tls providers |
| 3 | 🟢 Variables & Outputs | 18 | 2,970 | Beginner | Types, validation, sensitive, .tfvars |
| 4 | 🟡 State Management | 20 | 4,200 | Intermediate | Backends, import, mv, rm, drift |
| 5 | 🟡 Expressions & Functions | 20 | 3,900 | Intermediate | Built-ins, for, splat, dynamic |
| 6 | 🟡 Modules | 20 | 4,500 | Intermediate | Creating, calling, versioning |
| 7 | 🟡 Loops & Conditionals | 18 | 3,600 | Intermediate | count, for_each, dynamic blocks |
| 8 | 🟡 Data Sources | 15 | 3,000 | Intermediate | local, http, external, remote state |
| 9 | 🟡 Workspaces | 12 | 2,400 | Intermediate | Environments, isolation patterns |
| 10 | 🔴 Terraform Testing | 18 | 4,950 | Advanced | terraform test, mocks, assertions |
| 11 | 🔴 Security & Sensitive Data | 18 | 4,950 | Advanced | Secrets, encryption, policy |
| 12 | 🔴 Advanced HCL Patterns | 20 | 5,500 | Advanced | Meta-args, lifecycle, moved, import |
| 13 | 🔴 Debugging & Troubleshooting | 18 | 4,950 | Advanced | Logs, diffs, cycles, provider errors |
| 14 | ⚫ Performance & Scale | 15 | 5,250 | Expert | Parallelism, state splitting, large repos |
| 15 | ⚫ Production War Games | 20 | 8,500 | Expert | Multi-failure incidents, recovery |
| **TOTAL** | | **272** | **~63,870** | | |

---

Per-level lessons for all 15 modules are in [docs/LEVEL_CATALOG.md](docs/LEVEL_CATALOG.md) (rewritten so no two levels teach the same thing). The level file format and validator rules are in [docs/LEVEL_SPEC.md](docs/LEVEL_SPEC.md).

---

## XP Summary

| Module | Levels | Min XP | Max XP | Avg XP |
|---|---|---|---|---|
| 1 HCL Foundations | 20 | 100 | 150 | 118 |
| 2 Resource Basics | 20 | 100 | 150 | 131 |
| 3 Variables & Outputs | 18 | 100 | 200 | 152 |
| 4 State Management | 20 | 175 | 300 | 212 |
| 5 Expressions & Functions | 20 | 150 | 225 | 192 |
| 6 Modules | 20 | 175 | 275 | 229 |
| 7 Loops & Conditionals | 18 | 150 | 275 | 198 |
| 8 Data Sources | 15 | 150 | 250 | 202 |
| 9 Workspaces | 12 | 175 | 250 | 199 |
| 10 Testing | 18 | 225 | 325 | 271 |
| 11 Security | 18 | 225 | 325 | 277 |
| 12 Advanced Patterns | 20 | 250 | 400 | 298 |
| 13 Debugging | 18 | 225 | 350 | 278 |
| 14 Performance & Scale | 15 | 300 | 400 | 349 |
| 15 Production War Games | 20 | 350 | 600 | 430 |
| **TOTAL** | **272** | | | **~63,870** |

---

## Build Plan (Implementation Order)

### Phase 1 — Engine (Week 1)
- [ ] `play.sh` + `install.sh`
- [ ] `engine/engine.py` — game loop adapted for Terraform
- [ ] `engine/ui.py` — Rich terminal UI
- [ ] `engine/player.py` — player naming
- [ ] `engine/reset.py` — workspace copy + `terraform init`
- [ ] `engine/certificate.py` — module completion certs
- [ ] `scripts/generate_registry.py`
- [ ] `requirements.txt`

### Phase 2 — Modules 1–3 (Week 2)
- [ ] `scripts/build_levels.py` — scaffold for first 3 modules
- [ ] All 58 levels for modules 1, 2, 3

### Phase 3 — Modules 4–9 (Week 3–4)
- [ ] 105 levels for modules 4–9

### Phase 4 — Modules 10–15 (Week 5–6)
- [ ] 109 levels for modules 10–15

### Phase 5 — Polish
- [ ] Shell completion
- [ ] README
- [ ] `CONTRIBUTING.md`

---

## Key Design Decisions

1. **Workspace isolation**: The engine manages `workspace/current/` — player always edits there, never in `modules/`.
2. **`terraform init` on every reset**: Ensures providers are downloaded and `.terraform/` is clean.
3. **No cloud providers**: `local`, `null`, `random`, `tls`, `http`, `external` — everything runs offline.
4. **Docker provider optional**: Modules 12–15 can use `kreuzwerker/docker` for more realistic scenarios, but it's not required.
5. **Validator runs in workspace**: `validate.sh` uses `WORKSPACE` env var — all terraform commands run in `workspace/current/`.
6. **`terraform plan -detailed-exitcode`**: Exit 0=success+no-changes, 1=error, 2=success+changes. Validators use this correctly.
7. **Solution files are never applied**: They live in `modules/.../solution/` and are shown via `solution` command — never auto-applied.
