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
| `terraform` (1.5+) | ✅ Yes | `brew install terraform` |
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

## Module 1: HCL Foundations (20 Levels · Beginner · ~2,500 XP)

Learning goal: master HCL syntax, file structure, and the Terraform CLI workflow.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `first-resource` | Write first `resource` block — syntax error in block body | 100 | 5m |
| 2 | `block-types` | Distinguish `resource`, `variable`, `output`, `locals`, `data` blocks | 100 | 5m |
| 3 | `missing-provider` | `required_providers` block empty — `terraform init` fails | 125 | 5m |
| 4 | `provider-version` | Provider version constraint syntax wrong (`~> 2.0` vs `= 2.0`) | 125 | 8m |
| 5 | `terraform-block` | Missing `terraform {}` block entirely | 100 | 5m |
| 6 | `required-version` | `required_version` constraint incompatible with installed Terraform | 125 | 8m |
| 7 | `string-literals` | Unclosed string literal breaks entire config | 100 | 5m |
| 8 | `heredoc-syntax` | Heredoc `<<-EOF` used with wrong indentation stripping | 125 | 8m |
| 9 | `string-interpolation` | Broken `${}` expression inside string | 100 | 5m |
| 10 | `multiline-strings` | String spans lines without heredoc — parse error | 125 | 8m |
| 11 | `numeric-literals` | Wrong number literal in resource attribute (string vs number) | 100 | 5m |
| 12 | `boolean-values` | `"true"` (string) used where `bool` type expected | 100 | 5m |
| 13 | `null-values` | `null` used in non-nullable attribute | 125 | 8m |
| 14 | `comments-inline` | `//` comment breaks block statement — use `#` or `/* */` | 100 | 5m |
| 15 | `file-references` | `file()` call with wrong relative path | 125 | 8m |
| 16 | `multiple-files` | Config split across files — missing `variables.tf` referenced in `main.tf` | 150 | 10m |
| 17 | `locals-block` | `locals` block has duplicate key | 125 | 8m |
| 18 | `locals-cycle` | `locals` block has a self-referencing cycle | 150 | 10m |
| 19 | `resource-naming` | Invalid resource name (starts with digit) | 100 | 5m |
| 20 | `provider-alias` | `provider` alias declared but not referenced correctly | 150 | 10m |

---

## Module 2: Resource Basics (20 Levels · Beginner · ~2,700 XP)

Learning goal: work with real resources using the `local`, `null`, `random`, and `tls` providers.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `local-file-create` | `local_file` with wrong `filename` path | 100 | 5m |
| 2 | `local-file-content` | `local_file` — `content` vs `content_base64` mismatch | 125 | 8m |
| 3 | `local-sensitive-file` | `local_sensitive_file` — missing `file_permission` attribute | 125 | 8m |
| 4 | `random-string-config` | `random_string` — `length` attribute is 0 (invalid) | 100 | 5m |
| 5 | `random-string-special` | `random_string` — `special = true` but `override_special` empty string | 125 | 8m |
| 6 | `random-integer` | `random_integer` — `min` > `max` | 100 | 5m |
| 7 | `random-password` | `random_password` — `length` < `min_special + min_upper + min_lower + min_numeric` | 125 | 8m |
| 8 | `random-uuid` | `random_uuid` output referenced with wrong attribute name | 100 | 5m |
| 9 | `random-pet` | `random_pet` — `separator` attribute wrong type | 100 | 5m |
| 10 | `null-resource-trigger` | `null_resource` — `triggers` map has wrong value type | 125 | 8m |
| 11 | `null-resource-provisioner` | `null_resource` — `local-exec` provisioner has broken `command` | 150 | 10m |
| 12 | `tls-private-key` | `tls_private_key` — unsupported `algorithm` value | 125 | 8m |
| 13 | `tls-self-signed` | `tls_self_signed_cert` — `validity_period_hours` is negative | 125 | 8m |
| 14 | `tls-cert-request` | `tls_cert_request` — missing required `subject` block | 150 | 10m |
| 15 | `resource-reference` | Resource attribute reference uses wrong syntax (`resource.type.name` instead of `type.name`) | 125 | 8m |
| 16 | `implicit-dependency` | Resource depends on another but reference is broken — wrong attribute | 150 | 10m |
| 17 | `explicit-depends-on` | `depends_on` references non-existent resource | 150 | 10m |
| 18 | `resource-timeout` | `timeouts` block uses string format instead of duration | 125 | 8m |
| 19 | `lifecycle-prevent-destroy` | `prevent_destroy = true` blocks required plan — need to remove it | 150 | 10m |
| 20 | `lifecycle-ignore-changes` | `ignore_changes` list contains wrong attribute names | 150 | 10m |

---

## Module 3: Variables & Outputs (18 Levels · Beginner-Intermediate · ~2,970 XP)

Learning goal: master all variable types, validation, sensitive data, and output blocks.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `string-variable` | Variable type declared as `number` but default is a string | 100 | 5m |
| 2 | `number-variable` | Variable default is a string `"42"` but type is `number` | 100 | 5m |
| 3 | `bool-variable` | Variable default is `"false"` (string) instead of `false` | 100 | 5m |
| 4 | `list-variable` | `list(string)` variable — default contains a number element | 125 | 8m |
| 5 | `map-variable` | `map(string)` variable — default value has mixed types | 125 | 8m |
| 6 | `object-variable` | `object({})` missing required attribute in default | 150 | 10m |
| 7 | `set-variable` | `set(string)` — duplicate elements in default | 125 | 8m |
| 8 | `tuple-variable` | `tuple([string, number])` — wrong element types in default | 150 | 10m |
| 9 | `any-type` | `type = any` with incompatible downstream usage | 150 | 10m |
| 10 | `variable-validation` | `validation` block — `condition` expression is always `false` | 175 | 10m |
| 11 | `variable-validation-message` | `validation` block — `error_message` is empty string | 150 | 10m |
| 12 | `nullable-variable` | `nullable = false` variable has `null` default | 175 | 10m |
| 13 | `sensitive-variable` | Sensitive variable value exposed in output without `sensitive = true` | 175 | 12m |
| 14 | `output-reference` | Output references a resource attribute that doesn't exist | 125 | 8m |
| 15 | `output-depends-on` | Output `depends_on` has wrong resource reference | 150 | 10m |
| 16 | `tfvars-file` | `.tfvars` file has syntax error (missing `=`) | 150 | 10m |
| 17 | `variable-precedence` | Same variable set in `.tfvars` and env var — understanding override order | 175 | 12m |
| 18 | `complex-object-output` | Output trying to access nested object attribute with wrong key | 200 | 15m |

---

## Module 4: State Management (20 Levels · Intermediate · ~4,200 XP)

Learning goal: understand Terraform state operations, backends, import, and drift.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `state-inspect` | Use `terraform state list` + `show` to find a specific attribute | 175 | 10m |
| 2 | `state-move` | `terraform state mv` — wrong source address | 200 | 12m |
| 3 | `state-remove` | `terraform state rm` — removing a resource that blocks plan | 200 | 12m |
| 4 | `state-drift` | Real resource changed outside Terraform — fix drift with `terraform refresh` | 225 | 15m |
| 5 | `state-pull` | `terraform state pull` + manual JSON inspection | 200 | 12m |
| 6 | `state-push` | `terraform state push` — restoring a backup state | 225 | 15m |
| 7 | `import-resource` | `terraform import` — wrong address format | 200 | 12m |
| 8 | `import-block` | `import {}` block (TF 1.5+) — wrong `id` or `to` address | 200 | 12m |
| 9 | `import-block-generate` | `terraform plan -generate-config-out` — fix generated config | 250 | 20m |
| 10 | `moved-block` | `moved {}` block — wrong old/new addresses after refactor | 225 | 15m |
| 11 | `removed-block` | `removed {}` block (TF 1.7+) — resource removed from config but not from state | 225 | 15m |
| 12 | `lock-file` | `.terraform.lock.hcl` has wrong provider hash — fix and re-lock | 200 | 12m |
| 13 | `backend-local` | Local backend path wrong — state file not found | 175 | 10m |
| 14 | `backend-migration` | Backend changed — need `terraform init -migrate-state` | 225 | 15m |
| 15 | `partial-config` | Backend uses partial configuration — required vars missing | 225 | 15m |
| 16 | `targeted-apply` | `-target` flag — understanding dependency graph impact | 200 | 12m |
| 17 | `targeted-destroy` | `-target` with destroy — leaves orphaned dependencies | 225 | 15m |
| 18 | `force-replace` | `terraform apply -replace` — when to use vs taint | 225 | 15m |
| 19 | `tainted-resource` | Resource marked tainted — understand and resolve | 200 | 12m |
| 20 | `state-surgery` | Multi-step state recovery: remove + import + plan to clean | 300 | 25m |

---

## Module 5: Expressions & Built-in Functions (20 Levels · Intermediate · ~3,900 XP)

Learning goal: master Terraform's expression language, for expressions, and all function categories.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `format-function` | `format()` — wrong format specifier for type | 150 | 8m |
| 2 | `formatlist-function` | `formatlist()` — list length mismatch with format args | 175 | 10m |
| 3 | `string-functions` | `upper`, `lower`, `replace`, `trimspace` — wrong argument order | 150 | 8m |
| 4 | `split-join` | `split()` — wrong separator; result used with `join()` | 175 | 10m |
| 5 | `length-function` | `length()` on wrong type — map vs list vs string | 150 | 8m |
| 6 | `lookup-function` | `lookup(map, key, default)` — wrong number of args | 175 | 10m |
| 7 | `contains-index` | `contains()` / `index()` — element not in list → index panics | 175 | 10m |
| 8 | `flatten-compact` | `flatten()` returns nested structure — missing inner `flatten` | 200 | 12m |
| 9 | `concat-merge` | `concat()` vs `merge()` — used on wrong collection type | 175 | 10m |
| 10 | `setunion-intersection` | `setunion` / `setintersection` — wrong argument type (list not set) | 200 | 12m |
| 11 | `jsonencode-decode` | `jsonencode()` on incompatible type — fix type first | 200 | 12m |
| 12 | `templatefile` | `templatefile()` — template variable name mismatch | 200 | 12m |
| 13 | `cidrsubnet` | `cidrsubnet()` — newbits causes prefix overflow | 200 | 12m |
| 14 | `type-conversion` | `tostring()` / `tolist()` / `tomap()` — wrong target type | 175 | 10m |
| 15 | `ternary-expression` | Ternary with mismatched true/false types | 175 | 10m |
| 16 | `for-expression-list` | `for` expression — wrong element variable name | 175 | 10m |
| 17 | `for-expression-map` | `for` expression producing map — missing `=>` operator | 200 | 12m |
| 18 | `for-expression-filter` | `for` expression with `if` — filter condition always false | 200 | 12m |
| 19 | `splat-expression` | Splat `[*]` on a non-list (single resource, no `count`) | 225 | 15m |
| 20 | `string-directive` | `%{if}` / `%{for}` string template — wrong variable reference | 225 | 15m |

---

## Module 6: Reusable Modules (20 Levels · Intermediate · ~4,500 XP)

Learning goal: create, call, test, and version Terraform modules correctly.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `module-call-basic` | Module `source` path is wrong (relative vs absolute) | 175 | 10m |
| 2 | `module-input-missing` | Module call missing required input variable | 175 | 10m |
| 3 | `module-input-type` | Module input passed with wrong type | 200 | 12m |
| 4 | `module-output-reference` | Calling config references wrong module output name | 175 | 10m |
| 5 | `module-output-missing` | Module has no output block — caller can't access value | 200 | 12m |
| 6 | `module-version-constraint` | Module version constraint syntax broken | 200 | 12m |
| 7 | `module-count` | `count` on module — `count.index` not propagated to resources | 225 | 15m |
| 8 | `module-for-each` | `for_each` on module — wrong key access pattern | 225 | 15m |
| 9 | `module-depends-on` | `depends_on` on module call — wrong resource reference | 200 | 12m |
| 10 | `module-providers` | Module needs a provider alias — wrong `providers` map | 250 | 18m |
| 11 | `nested-module` | Nested module — `path.module` vs `path.root` confusion | 250 | 18m |
| 12 | `module-sensitive-output` | Sensitive output not marked — causes downstream plan diff | 225 | 15m |
| 13 | `module-variable-validation` | Module variable `validation` block references wrong var | 225 | 15m |
| 14 | `module-precondition` | `precondition` on module resource — wrong expression | 250 | 18m |
| 15 | `module-postcondition` | `postcondition` on output — assertion always fails | 250 | 18m |
| 16 | `module-refactor-moved` | Module refactored — missing `moved {}` blocks cause destroy/create | 275 | 20m |
| 17 | `module-composition` | Two modules have circular output dependency | 275 | 20m |
| 18 | `module-registry-format` | Local module converted to registry format — wrong file structure | 225 | 15m |
| 19 | `module-test-basic` | `terraform test` file has wrong `run` block format | 275 | 20m |
| 20 | `module-test-assert` | Test `assert` block condition logic is inverted | 275 | 20m |

---

## Module 7: Loops & Conditionals (18 Levels · Intermediate · ~3,600 XP)

Learning goal: master `count`, `for_each`, dynamic blocks, and conditional resource creation.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `count-basics` | `count = 3` but resource name doesn't use `count.index` | 150 | 8m |
| 2 | `count-zero` | `count = 0` accidentally — resource not created | 150 | 8m |
| 3 | `count-index-off-by-one` | `count.index + 1` vs `count.index` in filename | 175 | 10m |
| 4 | `count-conditional` | `count = var.enabled ? 1 : 0` — `var.enabled` is wrong type | 200 | 12m |
| 5 | `count-output-splat` | Output of counted resource uses `[0]` instead of `[*]` | 200 | 12m |
| 6 | `for-each-set` | `for_each = toset(var.list)` — list has duplicates that break toset | 175 | 10m |
| 7 | `for-each-map` | `for_each = var.map` — resource body uses wrong key (`each.value` vs `each.key`) | 200 | 12m |
| 8 | `for-each-output` | `for k, v in resource.name : k => v.id` — wrong attribute | 200 | 12m |
| 9 | `for-each-dependency` | `for_each` resource references another `for_each` resource — unknown key | 225 | 15m |
| 10 | `for-each-empty` | `for_each = {}` accidentally — no resources created | 150 | 8m |
| 11 | `for-each-count-mix` | Module uses `count`, caller uses `for_each` — address mismatch | 250 | 18m |
| 12 | `dynamic-block-basics` | `dynamic` block name doesn't match nested block type | 200 | 12m |
| 13 | `dynamic-block-content` | `dynamic` block `content {}` references wrong `each` value | 225 | 15m |
| 14 | `dynamic-optional-block` | Dynamic block with `for_each = var.x != null ? [var.x] : []` — null handling | 225 | 15m |
| 15 | `nested-for-each-flatten` | Nested `for_each` needs `flatten()` — missing flatten call | 250 | 18m |
| 16 | `for-each-known-after-apply` | `for_each` key comes from resource that doesn't exist yet — plan fails | 275 | 20m |
| 17 | `count-to-for-each-migration` | Migrating from `count` to `for_each` — missing `moved` blocks | 275 | 20m |
| 18 | `conditional-module-call` | Module called conditionally with `count` — output wrapped in list | 275 | 20m |

---

## Module 8: Data Sources (15 Levels · Intermediate · ~3,000 XP)

Learning goal: query external data using Terraform data sources.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `local-file-datasource` | `data.local_file` — wrong `filename` path | 150 | 8m |
| 2 | `local-file-content-access` | `data.local_file.x.content` vs `.content_base64` | 150 | 8m |
| 3 | `http-datasource` | `data.http` — wrong URL scheme | 175 | 10m |
| 4 | `http-response-parse` | `data.http` response body parsed with wrong `jsondecode` key | 200 | 12m |
| 5 | `external-datasource` | `data.external` — program returns non-JSON output | 200 | 12m |
| 6 | `external-datasource-program` | `data.external` — program path wrong (not executable) | 200 | 12m |
| 7 | `datasource-depends-on` | Data source needs `depends_on` resource that manages the file | 225 | 15m |
| 8 | `datasource-count` | `data` block with `count` — access pattern uses `[0]` when list needed | 200 | 12m |
| 9 | `datasource-for-each` | `data` block with `for_each` — wrong each variable in body | 200 | 12m |
| 10 | `datasource-in-module` | Module outputs a data source result — caller references wrong output | 200 | 12m |
| 11 | `datasource-refresh` | Data source returns stale result — understanding `-refresh-only` | 225 | 15m |
| 12 | `remote-state-datasource` | `terraform_remote_state` — wrong backend config | 250 | 18m |
| 13 | `remote-state-output` | `data.terraform_remote_state.x.outputs.name` — output name wrong | 225 | 15m |
| 14 | `datasource-filter` | Data source result filtered with `for` expression — wrong attribute name | 225 | 15m |
| 15 | `datasource-null-check` | Data source result is null — no null guard in downstream resource | 250 | 18m |

---

## Module 9: Workspaces (12 Levels · Intermediate · ~2,400 XP)

Learning goal: use workspaces for environment separation.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `workspace-create` | Wrong workspace selected — resources deploy to wrong env | 175 | 10m |
| 2 | `workspace-interpolation` | `terraform.workspace` in resource name — wrong string format | 175 | 10m |
| 3 | `workspace-conditional` | Conditional on `terraform.workspace == "prod"` — typo in name | 175 | 10m |
| 4 | `workspace-variable` | `locals` map keyed by workspace — missing workspace key | 200 | 12m |
| 5 | `workspace-count` | `count` based on workspace — default workspace edge case | 200 | 12m |
| 6 | `workspace-backend` | Backend path per workspace — path template wrong | 225 | 15m |
| 7 | `workspace-isolation` | Resources from different workspaces collide on same name | 225 | 15m |
| 8 | `workspace-for-each` | `for_each` map keyed by workspace — missing entries | 200 | 12m |
| 9 | `workspace-module-input` | Module input varies by workspace — lookup fails for new workspace | 225 | 15m |
| 10 | `workspace-destroy-order` | Destroying workspace with dependencies — wrong order | 225 | 15m |
| 11 | `workspace-list-select` | `terraform workspace list/select` errors — workspace doesn't exist | 175 | 10m |
| 12 | `workspace-vs-state-files` | Understanding when to use workspaces vs separate state files | 250 | 18m |

---

## Module 10: Terraform Testing Framework (18 Levels · Advanced · ~4,950 XP)

Learning goal: write `terraform test` files to validate modules and configurations.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `test-file-structure` | `.tftest.hcl` file — wrong top-level block type | 225 | 15m |
| 2 | `test-run-block` | `run` block missing required `command` attribute | 225 | 15m |
| 3 | `test-assert-basic` | `assert` block — condition expression wrong | 250 | 18m |
| 4 | `test-assert-message` | `assert` error message doesn't match actual failure | 225 | 15m |
| 5 | `test-expect-failures` | `expect_failures` — wrong address format for expected failure | 250 | 18m |
| 6 | `test-variables` | Test file overrides variable with wrong type | 250 | 18m |
| 7 | `test-multiple-runs` | Second `run` block uses output from first — wrong reference | 275 | 20m |
| 8 | `test-run-plan-only` | `command = plan` used but test asserts applied output value | 250 | 18m |
| 9 | `test-mock-provider` | `mock_provider` block — wrong mock resource attribute | 275 | 20m |
| 10 | `test-mock-resource` | `override_resource` — wrong resource address | 275 | 20m |
| 11 | `test-mock-data` | `override_data` — wrong data source address | 275 | 20m |
| 12 | `test-module-call` | Test calls a module — wrong relative source path | 250 | 18m |
| 13 | `test-output-sensitive` | Test asserts sensitive output value — wrong access pattern | 275 | 20m |
| 14 | `test-provider-config` | Test provides provider config that conflicts with module | 300 | 22m |
| 15 | `test-setup-module` | Setup module in test not cleaned up — state pollution | 300 | 22m |
| 16 | `test-complex-assertion` | Multi-condition assert with `&&` — short-circuit hides real error | 300 | 22m |
| 17 | `test-for-each-resource` | Test asserts property of `for_each` resource — wrong index | 300 | 22m |
| 18 | `test-precondition-validate` | Test that a `precondition` fails as expected — wrong `expect_failures` | 325 | 25m |

---

## Module 11: Security & Sensitive Data (18 Levels · Advanced · ~4,950 XP)

Learning goal: handle secrets, sensitive values, and security patterns in Terraform.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `sensitive-output-leak` | Output exposes sensitive variable — add `sensitive = true` | 225 | 15m |
| 2 | `sensitive-in-locals` | `local` computed from sensitive var loses sensitivity — fix | 250 | 18m |
| 3 | `nonsensitive-override` | `nonsensitive()` used incorrectly — exposes secret in plan | 250 | 18m |
| 4 | `secret-in-tfvars` | `.tfvars` file committed with secret — use env var instead | 225 | 15m |
| 5 | `env-var-secret` | `TF_VAR_` env var approach — wrong variable name format | 225 | 15m |
| 6 | `secret-in-state` | Understanding that secrets always appear in state — mitigation patterns | 275 | 20m |
| 7 | `tls-cert-chain` | TLS cert + key + CA chain — wrong attribute references between resources | 275 | 20m |
| 8 | `tls-cert-rotation` | TLS cert expired — `tls_self_signed_cert` with `early_renewal_hours` | 275 | 20m |
| 9 | `random-password-rotation` | `random_password` — keeper map needs updating for rotation | 275 | 20m |
| 10 | `file-permissions` | `local_sensitive_file` — wrong `file_permission` octal string | 250 | 18m |
| 11 | `prevent-destroy-prod` | `prevent_destroy` should be conditioned on workspace | 275 | 20m |
| 12 | `lifecycle-sensitive` | `ignore_changes` hiding security-relevant attribute drift | 300 | 22m |
| 13 | `validation-security` | Variable `validation` block enforcing security policy — condition wrong | 275 | 20m |
| 14 | `precondition-policy` | `precondition` enforcing security invariant — expression wrong | 300 | 22m |
| 15 | `postcondition-audit` | `postcondition` verifying output meets security requirement | 300 | 22m |
| 16 | `ephemeral-values` | Ephemeral values (TF 1.10+) — wrong block type | 300 | 22m |
| 17 | `state-backend-security` | Backend config leaks credentials — use partial config | 300 | 22m |
| 18 | `write-only-attributes` | Write-only attribute used incorrectly — reading a write-only value | 325 | 25m |

---

## Module 12: Advanced HCL Patterns (20 Levels · Advanced · ~5,500 XP)

Learning goal: meta-arguments, lifecycle rules, moved/removed blocks, and import blocks.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `provider-alias-multi` | Two provider instances — resource uses wrong alias | 250 | 18m |
| 2 | `provider-meta-argument` | `provider` meta-argument on resource — wrong alias reference | 250 | 18m |
| 3 | `create-before-destroy` | `create_before_destroy = true` — resource name collision during replace | 275 | 20m |
| 4 | `replace-triggered-by` | `replace_triggered_by` — wrong resource address in list | 275 | 20m |
| 5 | `moved-block-rename` | Renaming a resource — `moved` block source/dest swapped | 275 | 20m |
| 6 | `moved-block-module` | Moving resource into a module — wrong address format | 300 | 22m |
| 7 | `moved-block-for-each` | Resource moved from `count` to named — `moved` block instance key | 300 | 22m |
| 8 | `removed-block-destroy` | `removed {}` with `lifecycle { destroy = false }` — misuse | 275 | 20m |
| 9 | `import-block-address` | `import` block — `to` address has wrong module path | 300 | 22m |
| 10 | `import-block-id` | `import` block — `id` format wrong for provider | 300 | 22m |
| 11 | `import-block-generated` | Generated config from `-generate-config-out` has type errors | 325 | 25m |
| 12 | `postcondition-output` | `postcondition` on output — references wrong attribute | 275 | 20m |
| 13 | `precondition-resource` | `precondition` on resource `lifecycle` — condition always fails | 275 | 20m |
| 14 | `dynamic-nested-block` | Double-nested `dynamic` block — inner iterator shadows outer | 300 | 22m |
| 15 | `provider-iteration` | Provider `for_each` (TF 1.12) — wrong address format | 325 | 25m |
| 16 | `stack-references` | Cross-stack references (Terraform Stacks) — wrong component path | 325 | 25m |
| 17 | `ephemeral-resource` | Ephemeral resource block (TF 1.10+) used as permanent resource | 300 | 22m |
| 18 | `check-block` | `check` block (TF 1.5+) — `assert` inside check vs lifecycle | 300 | 22m |
| 19 | `identity-token` | `identity_token` block for OIDC auth — wrong audience | 325 | 25m |
| 20 | `complex-refactor` | Full refactor: count→for_each + moved + removed + import | 400 | 30m |

---

## Module 13: Debugging & Troubleshooting (18 Levels · Advanced · ~4,950 XP)

Learning goal: diagnose and fix all categories of Terraform errors.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `tf-log-debug` | Use `TF_LOG=DEBUG` to find root cause of init failure | 225 | 15m |
| 2 | `provider-error-message` | Provider error — wrong attribute type, fix from error message | 225 | 15m |
| 3 | `plan-error-diagnosis` | `terraform plan` fails with "inconsistent result" — find cause | 250 | 18m |
| 4 | `apply-error-partial` | Partial apply left resources in broken state — recovery plan | 275 | 20m |
| 5 | `cycle-detection` | Dependency cycle between two resources — break cycle | 275 | 20m |
| 6 | `unknown-value-propagation` | "known after apply" propagates through config — fix ordering | 275 | 20m |
| 7 | `perpetual-diff` | Plan always shows changes even after apply — find and fix | 300 | 22m |
| 8 | `lock-file-conflict` | `.terraform.lock.hcl` provider hash mismatch after upgrade | 250 | 18m |
| 9 | `init-failure` | `terraform init` fails — wrong provider registry URL | 225 | 15m |
| 10 | `provider-version-conflict` | Two modules require conflicting provider versions | 275 | 20m |
| 11 | `state-inconsistency` | State shows resource exists but plan wants to create it | 300 | 22m |
| 12 | `import-conflict` | Importing resource that already exists in state | 275 | 20m |
| 13 | `provider-timeout` | Provider operation times out — configure timeout settings | 275 | 20m |
| 14 | `sensitive-value-error` | Error about sensitive value in unexpected context — fix propagation | 275 | 20m |
| 15 | `null-attribute-access` | Accessing attribute of `null` output — add null guard | 275 | 20m |
| 16 | `for-each-unknown-key` | `for_each` key is unknown at plan time — structural fix | 325 | 25m |
| 17 | `complex-dependency-debug` | Multi-resource dependency issue requires graph analysis | 325 | 25m |
| 18 | `crash-log-analysis` | Terraform crash log — identify provider bug and workaround | 350 | 30m |

---

## Module 14: Performance & Scale (15 Levels · Expert · ~5,250 XP)

Learning goal: optimize Terraform for large codebases and teams.

| # | Level Name | Concept | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `parallelism-tuning` | `-parallelism` flag — default 10, fix race condition | 300 | 22m |
| 2 | `targeted-operations` | `-target` use and misuse — fix collateral damage | 300 | 22m |
| 3 | `refresh-false` | `-refresh=false` for speed — understand when it's safe | 325 | 25m |
| 4 | `refresh-only-mode` | `terraform apply -refresh-only` for drift detection only | 325 | 25m |
| 5 | `state-partition` | Large state split across multiple configs — `terraform_remote_state` | 350 | 28m |
| 6 | `module-splitting` | Monolithic module split into composable pieces | 350 | 28m |
| 7 | `large-for-each` | `for_each` over 1000+ resources — optimize plan time | 350 | 28m |
| 8 | `plan-out-file` | `terraform plan -out=plan.tfplan` + `apply plan.tfplan` | 300 | 22m |
| 9 | `plan-out-security` | Plan file contains sensitive data — understand risks | 350 | 28m |
| 10 | `provider-caching` | `TF_PLUGIN_CACHE_DIR` — fix cache directory issues | 325 | 25m |
| 11 | `lazy-evaluation` | Avoid eager evaluation of expensive expressions | 375 | 30m |
| 12 | `modular-monorepo` | Root modules for each component — shared module structure | 375 | 30m |
| 13 | `cross-team-state` | Remote state references across team boundaries | 375 | 30m |
| 14 | `workspace-scaling` | Workspace per environment at scale — naming conventions | 350 | 28m |
| 15 | `ci-cd-performance` | CI/CD pipeline Terraform optimizations — caching + targeting | 400 | 35m |

---

## Module 15: Production War Games (20 Levels · Expert · ~8,500 XP)

Learning goal: handle multi-failure production incidents using real Terraform recovery skills.

| # | Level Name | Incident | XP | Time |
|---|-----------|---------|-----|------|
| 1 | `state-corruption-recovery` | State file corrupted — restore from backup and reconcile | 350 | 30m |
| 2 | `drift-reconciliation` | 5 resources drifted simultaneously — find and fix all | 375 | 30m |
| 3 | `breaking-change-rollback` | Provider upgrade introduced breaking changes — downgrade path | 400 | 35m |
| 4 | `partial-apply-recovery` | Apply failed halfway — some resources created, some not | 400 | 35m |
| 5 | `destroy-protection-bypass` | `prevent_destroy` on wrong resource — remove and safely destroy | 400 | 35m |
| 6 | `cascade-dependency-failure` | Module A broken → Module B can't plan → Module C locked | 425 | 40m |
| 7 | `state-lock-timeout` | State lock timed out during apply — safe recovery | 400 | 35m |
| 8 | `incomplete-destroy` | `terraform destroy` interrupted — orphaned state entries | 425 | 40m |
| 9 | `module-upgrade-failure` | Module version bump causes 12 resource replacements — fix | 425 | 40m |
| 10 | `variable-propagation-chain` | Variable renamed across 3 nested modules — fix all refs | 425 | 40m |
| 11 | `address-refactor-at-scale` | 20 resources need moved/renamed — plan all moved blocks | 450 | 45m |
| 12 | `circular-module-dependency` | Two modules output-depend on each other — break cycle | 450 | 45m |
| 13 | `import-at-scale` | Import 15 existing resources into Terraform management | 450 | 45m |
| 14 | `state-split-operation` | Split monolithic state into 3 separate configs | 475 | 45m |
| 15 | `state-merge-operation` | Merge 3 separate states into one — order matters | 475 | 45m |
| 16 | `provider-auth-incident` | Provider authentication fails mid-pipeline — diagnosis + fix | 425 | 40m |
| 17 | `multi-team-conflict` | Two teams applied different configs — state conflicts | 450 | 45m |
| 18 | `emergency-state-surgery` | Manual JSON state edits to unblock a stuck deployment | 500 | 50m |
| 19 | `full-recovery-playbook` | Complete incident: corrupt state + drift + lock + cascade | 550 | 60m |
| 20 | `zero-downtime-refactor` | Refactor entire module structure with zero destroy/create | 600 | 60m |

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
