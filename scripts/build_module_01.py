#!/usr/bin/env python3
"""Module 1 — HCL Foundations (20 levels, Beginner)."""
from __future__ import annotations

from scripts.build_utils import (
    DEFAULT_TERRAFORM_TF,
    LOCAL_ONLY_TF,
    print_done,
    validate_tf_plan,
    validate_tf_validate,
    validate_output_equals,
    write_level,
)

MODULE = "module-1-foundations"


def build() -> int:
    levels = [
        _level_01_first_resource(),
        _level_02_block_types(),
        _level_03_missing_provider(),
        _level_04_provider_version(),
        _level_05_terraform_block(),
        _level_06_required_version(),
        _level_07_string_literals(),
        _level_08_heredoc_syntax(),
        _level_09_string_interpolation(),
        _level_10_multiline_strings(),
        _level_11_numeric_literals(),
        _level_12_boolean_values(),
        _level_13_null_values(),
        _level_14_comments_inline(),
        _level_15_file_references(),
        _level_16_multiple_files(),
        _level_17_locals_block(),
        _level_18_locals_cycle(),
        _level_19_resource_naming(),
        _level_20_provider_alias(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — first-resource
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_first_resource():
    return {
        "module": MODULE,
        "slug": "level-1-first-resource",
        "mission": {
            "name": "Your First Resource",
            "description": "A Terraform config was written to create a local file, but it has a syntax error and won't even parse.",
            "objective": "Fix the HCL syntax error so that `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["resource block", "HCL syntax", "terraform validate"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Fix the syntax error in this resource block.

resource "local_file" "greeting" {
  content  = "Hello, TerraformMissions!"
  filename = "${path.module}/greeting.txt"
  # Missing closing brace below — the block is not closed
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "greeting" {
  content  = "Hello, TerraformMissions!"
  filename = "${path.module}/greeting.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate` and read the error message carefully. It tells you the exact line and what is missing.",
            "Every `resource` block must be closed with a matching `}`. Count the opening and closing braces.",
            "Add the missing `}` at the end of the resource block.",
        ],
        "debrief": """\
# Your First Resource

## What Was Broken
The `resource` block was missing its closing brace `}`. HCL (HashiCorp Configuration Language) uses
matching `{` and `}` to delimit blocks. Without the closing brace, the parser cannot determine where
the block ends.

## The Fix
Add `}` at the end of the resource block to close it properly.

## Why It Matters
HCL syntax errors are the first class of problems you'll encounter. The `terraform validate` command
catches them without needing a provider connection. Always run `terraform validate` before `terraform plan`.

## Commands You Used
```bash
terraform validate   # static syntax + type check
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting the closing `}`** — every `{` needs a matching `}`.
- **Mismatched quotes** — strings must use double-quotes `"..."`.
- **Extra commas** — HCL does not use commas between argument assignments.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — block-types
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_block_types():
    return {
        "module": MODULE,
        "slug": "level-2-block-types",
        "mission": {
            "name": "Block Identity Crisis",
            "description": "The config uses the wrong keyword for declaring an output value — it says `outputs` instead of `output`.",
            "objective": "Fix the block keyword so the output is declared correctly and `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["output block", "block types", "HCL keywords"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/app.conf"
}

# Wrong keyword: "outputs" should be "output"
outputs "config_path" {
  value = local_file.config.filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/app.conf"
}

output "config_path" {
  value = local_file.config.filename
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says 'An argument or block definition is required' — look at the block keyword.",
            "Terraform has specific top-level block types: `resource`, `variable`, `output`, `locals`, `data`, `module`, `provider`, `terraform`. None of them are plural.",
            "Change `outputs` to `output`.",
        ],
        "debrief": """\
# Block Identity Crisis

## What Was Broken
`outputs` is not a valid HCL block type. The correct keyword is `output` (singular).

## Valid Top-Level Block Types
| Keyword    | Purpose |
|-----------|---------|
| `resource` | Declare a managed resource |
| `data`     | Declare a data source |
| `variable` | Declare an input variable |
| `output`   | Declare an output value |
| `locals`   | Declare local named values |
| `module`   | Call a child module |
| `provider` | Configure a provider |
| `terraform` | Terraform settings block |

## Why It Matters
HCL is strict about block type keywords. A typo like `outputs` instead of `output` is treated as
an unknown block type and causes a parse error. Unlike some languages, HCL does not silently ignore
unknown top-level blocks.
""",
        "common_mistakes": """\
# Common Mistakes

- **`outputs` instead of `output`** — the block keyword is always singular.
- **`variables` instead of `variable`** — same mistake with input variables.
- **`resources` instead of `resource`** — there is no plural form.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — missing-provider
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_missing_provider():
    return {
        "module": MODULE,
        "slug": "level-3-missing-provider",
        "mission": {
            "name": "The Missing Provider",
            "description": "`terraform init` fails because the required provider version does not exist.",
            "objective": "Fix the `required_providers` version constraint so that `terraform init` can download the provider.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["required_providers", "terraform block", "provider versions", "terraform init"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 99.0"  # No such version exists
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "readme" {
  content  = "Hello from Terraform!"
  filename = "${path.module}/README.txt"
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "readme" {
  content  = "Hello from Terraform!"
  filename = "${path.module}/README.txt"
}
""",
        },
        "validate": """\
#!/usr/bin/env bash
set -euo pipefail

# Re-run init (the broken version must have been fixed)
if terraform init -no-color -input=false 2>&1; then
    echo "✅ PASS: terraform init succeeded"
    exit 0
fi
echo "❌ FAIL: terraform init still failing"
exit 1
""",
        "hints": [
            "Run `terraform init` and read the error. It says the version constraint can't be satisfied.",
            "The `hashicorp/local` provider exists at versions like `2.4.x` and `2.5.x` — not `99.x`. Change `>= 99.0` to a realistic constraint.",
            "Use `~> 2.5` — this means 'any 2.x version >= 2.5', which is the recommended pattern.",
        ],
        "debrief": """\
# The Missing Provider

## What Was Broken
The version constraint `>= 99.0` demands a version of `hashicorp/local` that doesn't exist.
The Terraform registry has no version 99.x, so `terraform init` fails immediately.

## Version Constraint Syntax
| Constraint | Meaning |
|-----------|---------|
| `= 2.5.0`  | Exactly this version |
| `~> 2.5`   | >= 2.5.0, < 3.0.0 (pessimistic) |
| `>= 2.4`   | Any version 2.4 or higher |
| `>= 2.4, < 3.0` | Range |

## Best Practice
Use `~> X.Y` (pessimistic constraint operator) — it allows patch upgrades within a minor version,
which is the right balance between stability and security updates.

## Commands You Used
```bash
terraform init   # downloads providers specified in required_providers
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Constraint too strict** — `= 2.5.0` locks to one exact version; you won't get security patches.
- **Constraint too loose** — `>= 2.0` allows major version bumps with breaking changes.
- **Wrong operator** — `~> 2` allows `3.x`, `4.x` etc. Use `~> 2.5` to stay in the 2.x line.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — provider-version
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_provider_version():
    return {
        "module": MODULE,
        "slug": "level-4-provider-version",
        "mission": {
            "name": "Syntax Smash",
            "description": "The provider version constraint uses an invalid operator that Terraform doesn't recognise.",
            "objective": "Fix the version constraint operator so `terraform init` succeeds.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["version constraints", "~> operator", "required_providers"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~3.6"   # Invalid: ~3.6 is not valid syntax
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "validate": """\
#!/usr/bin/env bash
set -euo pipefail
if terraform init -no-color -input=false 2>&1; then
    echo "✅ PASS: terraform init succeeded"
    exit 0
fi
echo "❌ FAIL: terraform init still failing"
exit 1
""",
        "hints": [
            "The pessimistic constraint operator is `~>` (tilde-greater-than), not `~` alone.",
            "Look at the version string: `~3.6` is missing the `>`. The correct form is `~> 3.6`.",
            "Change `~3.6` to `~> 3.6`.",
        ],
        "debrief": """\
# Syntax Smash

## What Was Broken
`~3.6` is not a valid Terraform version constraint. The pessimistic operator requires both characters: `~>`.

## The Pessimistic Constraint Operator `~>`
`~> 3.6` means: allow `3.6.x` and above, but not `4.0` or higher.
It's called "pessimistic" because it assumes breaking changes happen at the next major/minor version.

```hcl
version = "~> 3.6"   # OK: 3.6.0, 3.6.5, 3.7.0 — NOT 4.0.0
version = "~> 3.0"   # OK: 3.0.0, 3.6.0 — NOT 4.0.0
```
""",
        "common_mistakes": """\
# Common Mistakes

- **`~3.6` instead of `~> 3.6`** — the `>` is required.
- **Confusing `~>` with `>=`** — `>=` has no upper bound; `~>` caps at the next major version.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — terraform-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_terraform_block():
    return {
        "module": MODULE,
        "slug": "level-5-terraform-block",
        "mission": {
            "name": "Block Disappeared",
            "description": "Someone deleted the entire `terraform {}` settings block. Terraform can still run but the provider source is unspecified, causing init to fail.",
            "objective": "Add back the `terraform {}` block with the correct `required_providers` entry for `hashicorp/local`.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["terraform block", "required_providers", "provider source"],
        },
        "broken": {
            "terraform.tf": """\
# The terraform {} block was accidentally deleted.
# Without it, Terraform cannot find the correct provider source.
""",
            "main.tf": """\
resource "local_file" "hosts" {
  content  = "127.0.0.1 localhost"
  filename = "${path.module}/hosts.txt"
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "hosts" {
  content  = "127.0.0.1 localhost"
  filename = "${path.module}/hosts.txt"
}
""",
        },
        "validate": """\
#!/usr/bin/env bash
set -euo pipefail
if terraform init -no-color -input=false 2>&1 && terraform validate -no-color 2>&1; then
    echo "✅ PASS: init and validate succeeded"
    exit 0
fi
echo "❌ FAIL"
exit 1
""",
        "hints": [
            "Without the `terraform {}` block, Terraform uses the 'legacy' provider lookup. Check `terraform init` output for a warning about provider sources.",
            "The `terraform {}` block belongs in `terraform.tf`. It must contain a `required_providers` block naming the providers you use.",
            "Add a `terraform { required_version ... required_providers { local = { source = \"hashicorp/local\", version = \"~> 2.5\" } } }` block.",
        ],
        "debrief": """\
# Block Disappeared

## What Was Broken
Without `required_providers`, Terraform falls back to the old provider discovery behaviour
(Terraform < 0.13) or errors on `terraform init` in newer versions because the source address
is unknown.

## The `terraform {}` Block
Every Terraform project should have a `terraform {}` block that declares:
- `required_version` — which Terraform version to use
- `required_providers` — where to find each provider and which version

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
```

## Why It Matters
Explicit provider sources prevent Terraform from guessing the provider origin and ensure
reproducible builds across machines and CI pipelines.
""",
        "common_mistakes": """\
# Common Mistakes

- **Omitting `required_providers` entirely** — Terraform will try to install the provider using legacy naming.
- **Wrong `source`** — `source` must be `"registry/namespace/provider"` or `"namespace/provider"`. The full form is `"registry.terraform.io/hashicorp/local"` but the short form `"hashicorp/local"` is equivalent.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — required-version
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_required_version():
    return {
        "module": MODULE,
        "slug": "level-6-required-version",
        "mission": {
            "name": "Version Lockout",
            "description": "The `required_version` constraint demands a Terraform version that doesn't exist, blocking all operations.",
            "objective": "Fix `required_version` to allow the currently installed Terraform version.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["required_version", "terraform version constraints"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = "= 0.11.0"   # Forces an ancient version
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "motd" {
  content  = "Welcome to TerraformMissions!"
  filename = "${path.module}/motd.txt"
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
""",
            "main.tf": """\
resource "local_file" "motd" {
  content  = "Welcome to TerraformMissions!"
  filename = "${path.module}/motd.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform version` to see your installed version. Then run `terraform validate` to see the constraint error.",
            "The constraint `= 0.11.0` means *exactly* Terraform 0.11.0 — nothing else. Your installed version is much newer.",
            "Change the constraint to `>= 1.5` to allow any modern Terraform.",
        ],
        "debrief": """\
# Version Lockout

## What Was Broken
`required_version = \"= 0.11.0\"` pins to an exact old version. Any modern Terraform installation
will be rejected with: `"Terraform v1.x.x does not meet version requirements (= 0.11.0)"`.

## Best Practices for `required_version`
```hcl
required_version = ">= 1.5"          # Allow any Terraform 1.5+
required_version = ">= 1.5, < 2.0"   # Explicit upper bound
required_version = "~> 1.5"          # 1.5.x only
```

## Real-World Use
In teams, `required_version` prevents junior engineers from running old Terraform against
infrastructure managed by a newer version. The state file format changes across major versions,
so this check protects data integrity.
""",
        "common_mistakes": """\
# Common Mistakes

- **Exact pinning `= X.Y.Z`** — overly strict; breaks the moment you upgrade.
- **No upper bound** — `>= 1.0` allows Terraform 2.x which may have breaking changes.
- **Forgetting to update after upgrading** — if you upgrade Terraform, bump `required_version` too.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — string-literals
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_string_literals():
    return {
        "module": MODULE,
        "slug": "level-7-string-literals",
        "mission": {
            "name": "Quote Disaster",
            "description": "A string value was entered with a mismatched quote — the string never closes, causing a parse error.",
            "objective": "Fix the unclosed string literal so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["string literals", "double quotes", "HCL syntax"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "database_url=postgres://localhost:5432/app   # Missing closing quote
  filename = "${path.module}/config.env"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "database_url=postgres://localhost:5432/app"
  filename = "${path.module}/config.env"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error mentions an 'Invalid string literal' or 'unterminated string'.",
            "Look at the `content` attribute. The string opens with `\"` but never closes — the `#` starts a comment inside what should still be a string.",
            "Add the closing `\"` after `app` on the `content` line.",
        ],
        "debrief": """\
# Quote Disaster

## What Was Broken
The `content` string was not closed with a matching `"`. Everything after the opening quote
(including the `#` comment) was treated as part of the string.

## HCL String Rules
- Strings are always delimited with **double quotes** `"..."`
- Single quotes are not valid in HCL
- To include a double quote inside a string, escape it: `\\"`
- To include a newline, use `\\n` or a heredoc (`<<-EOF`)

## When to Use Heredocs
For multi-line content, prefer heredocs:
```hcl
content = <<-EOF
  line 1
  line 2
EOF
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Unescaped double quotes inside a string** — use `\\"` to include a literal `"`.
- **Using single quotes** — not valid in HCL. Always use `"..."`.
- **Hash inside a string** — `#` is NOT a comment inside a string literal. Comments only work outside strings.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — heredoc-syntax
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_heredoc_syntax():
    return {
        "module": MODULE,
        "slug": "level-8-heredoc-syntax",
        "mission": {
            "name": "Heredoc Headache",
            "description": "A heredoc string is using `<<EOF` (non-indented) but the closing marker is indented, causing a parse error.",
            "objective": "Fix the heredoc so it uses `<<-EOF` (indented form) and `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["heredoc", "<<-EOF", "indented heredoc", "multiline strings"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "nginx_conf" {
  content  = <<EOF
    server {
      listen 80;
      server_name example.com;
    }
  EOF
  filename = "${path.module}/nginx.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "nginx_conf" {
  content  = <<-EOF
    server {
      listen 80;
      server_name example.com;
    }
  EOF
  filename = "${path.module}/nginx.conf"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "With `<<EOF`, the closing `EOF` marker must be at column 0 (no indentation). If it's indented, Terraform doesn't recognise it as the closing marker.",
            "Switch to the indented form `<<-EOF` — this strips leading whitespace and allows the closing marker to be indented.",
            "Change `<<EOF` to `<<-EOF` on the `content` line.",
        ],
        "debrief": """\
# Heredoc Headache

## What Was Broken
`<<EOF` (non-indented heredoc) requires the closing `EOF` marker to be at column 0.
The closing `  EOF` was indented, so Terraform kept reading past it.

## Two Heredoc Forms
| Form | Closing marker | Strips indentation |
|------|---------------|-------------------|
| `<<EOF` | Must be at column 0 | No |
| `<<-EOF` | Can be indented | Yes (strips leading whitespace) |

## Best Practice
Always use `<<-EOF` when your content is indented inside an HCL block.
This keeps the code visually aligned without requiring the closing marker to break indentation.

```hcl
content = <<-EOF
  line 1
  line 2
EOF
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing `<<EOF` with an indented closing marker** — use `<<-EOF` instead.
- **Trailing spaces after the closing marker** — `EOF  ` (with spaces) is not recognised as the marker.
- **Wrong marker name** — the opening and closing names must match exactly: `<<-MYMARKER` ... `MYMARKER`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — string-interpolation
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_string_interpolation():
    return {
        "module": MODULE,
        "slug": "level-9-string-interpolation",
        "mission": {
            "name": "Interpolation Implosion",
            "description": "A string interpolation expression uses `$()` instead of `${}`, which is shell syntax, not HCL.",
            "objective": "Fix the interpolation syntax so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["string interpolation", "${}", "expressions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type    = string
  default = "production"
}

resource "local_file" "env_file" {
  content  = "ENV=$(environment)"    # Wrong: $() is shell syntax
  filename = "${path.module}/env.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "environment" {
  type    = string
  default = "production"
}

resource "local_file" "env_file" {
  content  = "ENV=${var.environment}"
  filename = "${path.module}/env.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "HCL uses `${...}` for string interpolation, not `$(...)` which is bash syntax.",
            "Also check how the variable is referenced: it should be `var.environment`, not just `environment`.",
            "Fix the interpolation to `${var.environment}`.",
        ],
        "debrief": """\
# Interpolation Implosion

## What Was Broken
Two errors in one:
1. `$()` is bash command substitution — HCL uses `${}`
2. Inside HCL interpolation, variables are referenced as `var.name`, not just `name`

## HCL Interpolation
```hcl
"Hello, ${var.name}!"      # variable
"Path: ${path.module}"     # built-in reference
"ID: ${resource.type.name.attr}"  # resource attribute
```

## When NOT to Use Interpolation
If the entire value is a single reference, you don't need quotes at all:
```hcl
value = var.environment          # No interpolation needed
value = "${var.environment}"     # Works but unnecessary wrapper
```
The direct form `value = var.environment` is preferred by `terraform fmt`.
""",
        "common_mistakes": """\
# Common Mistakes

- **`$(...)` instead of `${...}`** — common for developers coming from bash.
- **Forgetting `var.` prefix** — `${environment}` is invalid; use `${var.environment}`.
- **Over-interpolating** — `"${var.x}"` can be simplified to `var.x` when the entire value is the variable.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — multiline-strings
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_multiline_strings():
    return {
        "module": MODULE,
        "slug": "level-10-multiline-strings",
        "mission": {
            "name": "String Escape",
            "description": "A multi-line string value was written without a heredoc — it spans two lines inside regular quotes, which is invalid HCL.",
            "objective": "Convert the broken multi-line string to a valid heredoc so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["multiline strings", "heredoc", "HCL string syntax"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "script" {
  content  = "#!/bin/bash
echo hello world"
  filename = "${path.module}/hello.sh"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "script" {
  content  = <<-EOF
    #!/bin/bash
    echo hello world
  EOF
  filename = "${path.module}/hello.sh"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Regular quoted strings in HCL cannot span multiple lines. Run `terraform validate` to see the parse error.",
            "For multi-line content, use a heredoc with `<<-EOF ... EOF`.",
            "Replace the broken quoted string with a `<<-EOF` heredoc block.",
        ],
        "debrief": """\
# String Escape

## What Was Broken
HCL does not allow a regular quoted string to span multiple lines. The newline inside `\"...\"` is a syntax error.

## Solutions for Multi-line Strings

**1. Escape sequences** (for simple cases):
```hcl
content = "line1\\nline2\\nline3"
```

**2. Heredoc** (for readable multi-line content):
```hcl
content = <<-EOF
  line 1
  line 2
EOF
```

**3. `file()` function** (for external files):
```hcl
content = file("${path.module}/script.sh")
```

Use heredocs for any content that is more than one line.
""",
        "common_mistakes": """\
# Common Mistakes

- **Bare newlines inside strings** — not allowed. Use `\\n` or a heredoc.
- **Forgetting `<<-` (indented form)** — `<<EOF` requires the closing marker at column 0.
- **Missing newline before closing marker** — the closing marker must be on its own line.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — numeric-literals
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_numeric_literals():
    return {
        "module": MODULE,
        "slug": "level-11-numeric-literals",
        "mission": {
            "name": "Type Confusion",
            "description": "A `random_string` resource has its `length` attribute set to a string `\"16\"` instead of a number `16`.",
            "objective": "Fix the type so `length` receives a number and `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["number type", "string type", "attribute types"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "token" {
  length  = "16"   # Wrong: should be a number, not a string
  special = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "`length` expects a number type. Run `terraform validate` to see 'Incorrect attribute value type'.",
            "In HCL, numbers are written without quotes: `16`, not `\"16\"`.",
            "Remove the quotes from the `length` value.",
        ],
        "debrief": """\
# Type Confusion

## What Was Broken
`length = \"16\"` passes a string where a number is expected. Terraform's type system is strict.

## HCL Primitive Types
| Type | Example |
|------|---------|
| `string` | `"hello"` |
| `number` | `42` or `3.14` |
| `bool` | `true` or `false` |

## Type Coercion
Terraform *will* auto-coerce in some cases (`\"16\"` → `16` for some providers), but this is
unreliable and provider-specific. Always use the correct type.

```hcl
length  = 16      # ✅ number
special = false   # ✅ bool
name    = "app"   # ✅ string
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting numbers** — `length = \"16\"` works sometimes but is wrong.
- **Quoting booleans** — `special = \"false\"` is a string, not a boolean.
- **Number in non-numeric context** — don't use bare `16` where a string is expected.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — boolean-values
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_boolean_values():
    return {
        "module": MODULE,
        "slug": "level-12-boolean-values",
        "mission": {
            "name": "True or False?",
            "description": "The `special` attribute is set to the string `\"true\"` instead of the boolean `true`, causing a type error.",
            "objective": "Fix the boolean attribute so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["bool type", "string vs bool", "type coercion"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_password" "db_pass" {
  length           = 20
  special          = "true"    # Wrong: string instead of bool
  override_special = "!@#$"
}

output "password" {
  value     = random_password.db_pass.result
  sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
""",
            "main.tf": """\
resource "random_password" "db_pass" {
  length           = 20
  special          = true
  override_special = "!@#$"
}

output "password" {
  value     = random_password.db_pass.result
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the type is wrong for `special`.",
            "Booleans in HCL are bare keywords: `true` and `false` — not quoted strings.",
            "Remove the quotes from `\"true\"` so it becomes `true`.",
        ],
        "debrief": """\
# True or False?

## What Was Broken
`special = \"true\"` is a string. Terraform expects a boolean `true` for that attribute.

## Booleans in HCL
```hcl
special = true     # ✅ boolean true
special = false    # ✅ boolean false
special = "true"   # ❌ this is a string
special = "false"  # ❌ this is a string
```

## When Does This Matter?
Many Terraform providers perform strict type checking. Even though Terraform has some automatic
type coercion, you should always use the correct type to avoid surprises.
""",
        "common_mistakes": """\
# Common Mistakes

- **Quoting booleans** — `\"true\"` is not a boolean.
- **Capitalising** — `True` and `False` are not valid. HCL booleans are lowercase.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — null-values
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_null_values():
    return {
        "module": MODULE,
        "slug": "level-13-null-values",
        "mission": {
            "name": "Null and Void",
            "description": "A variable marked `nullable = false` has a `default = null`. This combination is invalid — a non-nullable variable cannot default to null.",
            "objective": "Fix the variable declaration so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["nullable", "null", "variable defaults", "type constraints"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "app_name" {
  type     = string
  nullable = false
  default  = null    # Contradiction: nullable=false but default is null
}

resource "local_file" "app_config" {
  content  = "app=${var.app_name}"
  filename = "${path.module}/app.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "app_name" {
  type     = string
  nullable = false
  default  = "myapp"
}

resource "local_file" "app_config" {
  content  = "app=${var.app_name}"
  filename = "${path.module}/app.conf"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It reports a contradiction between `nullable = false` and `default = null`.",
            "`nullable = false` means the variable must always have a non-null value. You can't default it to `null`.",
            "Either remove `nullable = false`, or change `default = null` to a real default value like `default = \"myapp\"`.",
        ],
        "debrief": """\
# Null and Void

## What Was Broken
`nullable = false` means the variable must never be null. A `default = null` contradicts this
because null *is* the absence of value.

## `nullable` in Terraform
Added in Terraform 1.1. Controls whether a variable can be `null`:

```hcl
variable "x" {
  type     = string
  nullable = false   # callers CANNOT pass null
  default  = "prod"  # must be a non-null default
}

variable "y" {
  type     = string
  nullable = true    # (default) callers CAN pass null
  default  = null    # fine — null is allowed
}
```

## Use Case
`nullable = false` is useful when you want to guarantee a variable always has a value,
preventing null-propagation bugs deep in your module.
""",
        "common_mistakes": """\
# Common Mistakes

- **`nullable = false` with `default = null`** — the contradiction Terraform catches at validate time.
- **Forgetting that `nullable = true` is the default** — you only need to set it if you want to forbid null.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — comments-inline
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_comments_inline():
    return {
        "module": MODULE,
        "slug": "level-14-comments-inline",
        "mission": {
            "name": "Comment Catastrophe",
            "description": "A `/* block comment */` was left unclosed inside an attribute assignment, corrupting the entire config.",
            "objective": "Fix or remove the unclosed block comment so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["comments", "# inline comment", "/* block comment */", "HCL syntax"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "notes" {
  content  = "deployment notes" /* TODO: expand this
  filename = "${path.module}/notes.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "notes" {
  content  = "deployment notes" # TODO: expand this
  filename = "${path.module}/notes.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "A `/* comment */` block must be closed with `*/`. An unclosed `/*` swallows everything after it.",
            "HCL supports three comment styles: `#`, `//`, and `/* ... */`. Use `#` or `//` for single-line comments.",
            "Replace `/* TODO: expand this` with `# TODO: expand this`.",
        ],
        "debrief": """\
# Comment Catastrophe

## What Was Broken
`/* TODO: expand this` opens a block comment but never closes it. Everything after `/*` —
including the `filename` line and the closing `}` — becomes part of the comment.

## HCL Comment Styles
| Style | Example | Notes |
|-------|---------|-------|
| `#`   | `# comment` | Single-line; preferred by `terraform fmt` |
| `//`  | `// comment` | Single-line; less common |
| `/* */` | `/* multi-line */` | Block comment; must close with `*/` |

## Best Practice
Use `#` for inline comments. Reserve `/* */` only when you genuinely need a multi-line comment block.
""",
        "common_mistakes": """\
# Common Mistakes

- **Unclosed `/* */`** — the parser treats everything until `*/` as the comment.
- **Using `//` in shell scripts inside `local-exec`** — `//` is a comment in HCL but not in bash.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — file-references
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_file_references():
    return {
        "module": MODULE,
        "slug": "level-15-file-references",
        "mission": {
            "name": "File Not Found",
            "description": "The `templatefile()` function references a template file that doesn't exist at the given path.",
            "objective": "Create the missing template file (or fix the path) so `terraform plan` succeeds.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["templatefile()", "file()", "path.module", "relative paths"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "nginx" {
  content  = templatefile("${path.module}/templates/nginx.conf.tpl", {
    port = 80
    hostname = "example.com"
  })
  filename = "${path.module}/nginx.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "nginx" {
  content  = templatefile("${path.module}/nginx.conf.tpl", {
    port     = 80
    hostname = "example.com"
  })
  filename = "${path.module}/nginx.conf"
}
""",
            "nginx.conf.tpl": """\
server {
  listen ${port};
  server_name ${hostname};
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan` — it fails because `templates/nginx.conf.tpl` doesn't exist.",
            "Either create a `templates/` directory with the template file, or fix the path.",
            "Simplest fix: change the path to `\"${path.module}/nginx.conf.tpl\"` and create `nginx.conf.tpl` directly in the workspace (it's already in the solution/).",
        ],
        "debrief": """\
# File Not Found

## What Was Broken
`templatefile()` is evaluated at plan time — if the template file doesn't exist,
`terraform plan` fails immediately with "no such file or directory".

## `path.module` vs `path.cwd`
| Reference | Points to |
|-----------|-----------|
| `path.module` | Directory containing the `.tf` file |
| `path.cwd` | Current working directory when terraform was invoked |
| `path.root` | Root module directory |

## Best Practice
Always use `path.module` when referencing files relative to your configuration.
This ensures the path works correctly when the config is called as a module.

## `file()` vs `templatefile()`
- `file(path)` — reads file contents as a plain string
- `templatefile(path, vars)` — reads file and renders `${variable}` placeholders
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong directory depth** — `templates/nginx.conf.tpl` requires a `templates/` subdirectory.
- **Forgetting `path.module`** — bare relative paths like `\"nginx.conf.tpl\"` depend on cwd, which changes in CI.
- **Using `file()` instead of `templatefile()`** — `file()` doesn't substitute variables.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — multiple-files
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_multiple_files():
    return {
        "module": MODULE,
        "slug": "level-16-multiple-files",
        "mission": {
            "name": "Split Personality",
            "description": "`main.tf` references a variable defined in `variables.tf`, but `variables.tf` is missing from the config.",
            "objective": "Create `variables.tf` with the correct variable declaration so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "beginner",
            "expected_time": "10m",
            "concepts": ["file organisation", "variables.tf", "variable declaration", "multi-file configs"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# main.tf references var.environment, but variables.tf is missing.

resource "local_file" "env_config" {
  content  = "ENVIRONMENT=${var.environment}\\nDEBUG=${var.debug}"
  filename = "${path.module}/app.env"
}

output "config_file" {
  value = local_file.env_config.filename
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "env_config" {
  content  = "ENVIRONMENT=${var.environment}\\nDEBUG=${var.debug}"
  filename = "${path.module}/app.env"
}

output "config_file" {
  value = local_file.env_config.filename
}
""",
            "variables.tf": """\
variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, production)"
  default     = "development"
}

variable "debug" {
  type        = bool
  description = "Enable debug mode"
  default     = false
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says `var.environment` is an undeclared variable.",
            "In Terraform, variables must be declared before use. Create a `variables.tf` file in the workspace.",
            "Add variable blocks for `environment` (string) and `debug` (bool) to `variables.tf`.",
        ],
        "debrief": """\
# Split Personality

## What Was Broken
`main.tf` referenced `var.environment` and `var.debug`, but no `variable` blocks were declared.
Terraform loads all `.tf` files in the directory as a single configuration, but each variable
must be explicitly declared.

## File Organisation Convention
Terraform has no enforced file structure, but this convention is widely adopted:

| File | Contents |
|------|----------|
| `main.tf` | Primary resources |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output value declarations |
| `locals.tf` | Local value declarations |
| `versions.tf` / `terraform.tf` | Provider + Terraform block |

## All `.tf` Files Are Equal
Terraform merges all `.tf` files in the same directory. You can declare a variable in any `.tf`
file — the convention is `variables.tf` purely for readability.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using a variable without declaring it** — `var.x` always requires a corresponding `variable \"x\" {}` block.
- **Declaring variables in subdirectories** — subdirectory `.tf` files are not loaded by the parent module.
- **Duplicate variable declarations** — declaring the same variable twice is an error.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — locals-block
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_locals_block():
    return {
        "module": MODULE,
        "slug": "level-17-locals-block",
        "mission": {
            "name": "Double Vision",
            "description": "The `locals` block declares the same key `app_name` twice, which is not allowed.",
            "objective": "Fix the duplicate local value so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["locals", "local values", "duplicate keys"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  app_name    = "frontend"
  app_name    = "backend"   # Duplicate key — not allowed
  environment = "staging"
}

resource "local_file" "config" {
  content  = "app=${local.app_name} env=${local.environment}"
  filename = "${path.module}/service.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
locals {
  app_name    = "backend"
  environment = "staging"
}

resource "local_file" "config" {
  content  = "app=${local.app_name} env=${local.environment}"
  filename = "${path.module}/service.conf"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says 'An argument named \"app_name\" was already set'.",
            "A `locals` block is like a map — you cannot have two entries with the same key.",
            "Remove or rename the duplicate `app_name` entry.",
        ],
        "debrief": """\
# Double Vision

## What Was Broken
`locals` blocks are key-value maps. Duplicate keys are a parse error.

## locals vs variables
| | `variable` | `local` |
|--|-----------|---------|
| Set by | caller / env / tfvars | defined in config |
| Read-only | ✅ | ✅ |
| Can reference other locals | ❌ | ✅ |
| Can be overridden externally | ✅ | ❌ |

## Using locals for DRY code
```hcl
locals {
  prefix = "${var.env}-${var.region}"
  bucket_name = "${local.prefix}-data"
}
```

Locals are great for computed values or to avoid repeating the same expression.
""",
        "common_mistakes": """\
# Common Mistakes

- **Duplicate keys in `locals`** — each name must be unique within a locals block.
- **Multiple `locals` blocks** — allowed (Terraform merges them), but having duplicates across blocks is still an error.
- **Confusing `local.x` with `var.x`** — locals are referenced with `local.` (no 's'), variables with `var.`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — locals-cycle
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_locals_cycle():
    return {
        "module": MODULE,
        "slug": "level-18-locals-cycle",
        "mission": {
            "name": "Circular Reference",
            "description": "Two local values reference each other, creating a dependency cycle that Terraform cannot resolve.",
            "objective": "Break the cycle by rewriting the locals so each one is independently computable. `terraform validate` must pass.",
            "xp": 150,
            "difficulty": "beginner",
            "expected_time": "10m",
            "concepts": ["locals", "dependency cycles", "expression evaluation"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "base_name" {
  type    = string
  default = "myapp"
}

locals {
  full_name = "${local.prefix}-${var.base_name}"  # references local.prefix
  prefix    = "${local.full_name}-svc"            # references local.full_name → CYCLE
}

resource "local_file" "info" {
  content  = local.full_name
  filename = "${path.module}/info.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "base_name" {
  type    = string
  default = "myapp"
}

locals {
  prefix    = "svc"
  full_name = "${local.prefix}-${var.base_name}"
}

resource "local_file" "info" {
  content  = local.full_name
  filename = "${path.module}/info.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It reports 'Cycle: local.full_name, local.prefix'.",
            "`local.full_name` depends on `local.prefix`, which depends on `local.full_name` — infinite loop.",
            "Rewrite so that `prefix` is a standalone value (e.g. `prefix = \"svc\"`), and `full_name` uses it.",
        ],
        "debrief": """\
# Circular Reference

## What Was Broken
`local.full_name` → `local.prefix` → `local.full_name` — a cycle with no resolution.
Terraform evaluates locals lazily using dependency ordering (topological sort). A cycle has no
valid ordering, so it's a hard error.

## Detecting Cycles
```
Error: Cycle: local.full_name, local.prefix
```
Terraform lists all the nodes in the cycle. Follow the arrows to find the loop.

## Fix Strategy
1. Identify which value *should* be the "base" (no dependencies on other locals)
2. Express it as a constant or pure expression using only `var.*`
3. Build derived locals from that base

```hcl
locals {
  prefix    = "svc"                              # base — no local deps
  full_name = "${local.prefix}-${var.base_name}" # derived — fine
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Mutual locals** — two locals that each reference the other.
- **Three-node cycles** — A→B→C→A are harder to spot; run `terraform validate` to find them.
- **Cycle through resources** — `resource A` → `local X` → `resource A attr` — also a cycle.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — resource-naming
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_resource_naming():
    return {
        "module": MODULE,
        "slug": "level-19-resource-naming",
        "mission": {
            "name": "The Name Game",
            "description": "The resource has an invalid name that starts with a digit, which is not allowed in HCL identifiers.",
            "objective": "Rename the resource with a valid identifier so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["resource naming", "HCL identifiers", "naming conventions"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Resource names must start with a letter or underscore, not a digit.

resource "local_file" "1_config" {
  content  = "version=1"
  filename = "${path.module}/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "v1_config" {
  content  = "version=1"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says 'Invalid identifier' for the resource name.",
            "HCL identifiers must start with a letter (a-z, A-Z) or underscore `_`. Digits are allowed after the first character.",
            "Rename `1_config` to something like `v1_config` or `config_v1`.",
        ],
        "debrief": """\
# The Name Game

## What Was Broken
`\"1_config\"` starts with a digit. HCL identifiers follow the same rule as most programming languages:
they must begin with a letter or underscore.

## Valid HCL Identifier Rules
- Start with: `a-z`, `A-Z`, or `_`
- Continue with: `a-z`, `A-Z`, `0-9`, `-`, or `_`
- Case-sensitive: `My_Resource` ≠ `my_resource`

## Naming Conventions
```hcl
resource "local_file" "app_config"     # snake_case (preferred by terraform fmt)
resource "local_file" "appConfig"      # camelCase (works but not idiomatic)
resource "local_file" "app-config"     # kebab-case (valid but less common)
```

Use `snake_case` — it's the community standard enforced by `terraform fmt`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Starting with a digit** — prefix with a letter: `1_config` → `v1_config`.
- **Using reserved words** — don't name resources `self`, `each`, `count`, or `path`.
- **Using dots in names** — dots are not valid in resource names (they separate type.name in references).
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — provider-alias
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_provider_alias():
    return {
        "module": MODULE,
        "slug": "level-20-provider-alias",
        "mission": {
            "name": "Alias Identity",
            "description": "A provider alias is declared but the resource uses a wrong alias reference, causing a validation error.",
            "objective": "Fix the `provider` meta-argument on the resource to correctly reference the declared alias.",
            "xp": 150,
            "difficulty": "beginner",
            "expected_time": "10m",
            "concepts": ["provider alias", "provider meta-argument", "multiple providers"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Two local provider instances with different path prefixes
provider "local" {
  alias = "primary"
}

resource "local_file" "config" {
  content  = "primary config"
  filename = "${path.module}/config.txt"

  provider = local.secondary   # Wrong: alias "secondary" was never declared
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
provider "local" {
  alias = "primary"
}

resource "local_file" "config" {
  content  = "primary config"
  filename = "${path.module}/config.txt"

  provider = local.primary
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. It says 'provider configuration not present' for `local.secondary`.",
            "Only `local.primary` was declared via `provider \"local\" { alias = \"primary\" }`. There is no `local.secondary`.",
            "Change `provider = local.secondary` to `provider = local.primary`.",
        ],
        "debrief": """\
# Alias Identity

## What Was Broken
The `provider` meta-argument referenced `local.secondary`, but only `local.primary` was declared.

## Provider Aliases
Aliases allow multiple instances of the same provider — useful for different regions, accounts, or configs.

```hcl
provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

resource "local_file" "a" {
  provider = local.primary
  # ...
}

resource "local_file" "b" {
  provider = local.secondary
  # ...
}
```

## When You Need Aliases
- Multi-region deployments (one provider per region)
- Multi-account deployments
- Different provider configurations for different resources

## Default Provider
If no `alias` is set on a `provider` block, it becomes the *default* provider for that type.
Resources without a `provider` meta-argument use the default.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing an undeclared alias** — every alias must have a matching `provider` block.
- **Forgetting the alias on the provider block** — `provider \"local\" {}` without `alias` is the default, not an alias.
- **Wrong syntax** — `provider = \"local.primary\"` (string) is wrong; use `provider = local.primary` (reference).
""",
    }
