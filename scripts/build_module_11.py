#!/usr/bin/env python3
"""Module 11 — Security & Sensitive Data (18 levels, Advanced)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    TLS_ONLY_TF,
    print_done,
    validate_tf_apply,
    validate_tf_validate,
    write_level,
)

MODULE = "module-11-security"

LOCAL_RANDOM_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
"""

LOCAL_TLS_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
"""


def build() -> int:
    levels = [
        _level_01_sensitive_output_leak(),
        _level_02_sensitive_in_locals(),
        _level_03_nonsensitive_override(),
        _level_04_secret_in_tfvars(),
        _level_05_env_var_secret(),
        _level_06_secret_in_state(),
        _level_07_tls_cert_chain(),
        _level_08_tls_cert_rotation(),
        _level_09_random_password_rotation(),
        _level_10_file_permissions(),
        _level_11_prevent_destroy_prod(),
        _level_12_lifecycle_sensitive(),
        _level_13_validation_security(),
        _level_14_precondition_policy(),
        _level_15_postcondition_audit(),
        _level_16_ephemeral_values(),
        _level_17_state_backend_security(),
        _level_18_write_only_attributes(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — sensitive-output-leak
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_sensitive_output_leak():
    return {
        "module": MODULE,
        "slug": "level-1-sensitive-output-leak",
        "mission": {
            "name": "Sensitive Output Leak",
            "description": "An output exposes `random_password.db.result` without marking it `sensitive = true`. The raw password will be printed to the terminal and stored in state in plaintext output.",
            "objective": "Add `sensitive = true` to the output so the password is redacted and `terraform validate` passes.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["sensitive output", "random_password", "secret management"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length  = 16
  special = true
}

# Broken: exposes the password in plain output
output "db_password" {
  value = random_password.db.result
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length  = 16
  special = true
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The config is syntactically valid but the output leaks a secret. Check the `output` block for the `sensitive` argument.",
            "Adding `sensitive = true` to an output causes Terraform to redact the value in all CLI output and to mark it as sensitive in downstream consumers.",
            "Add `sensitive = true` inside the `output \"db_password\"` block.",
        ],
        "debrief": """\
# Sensitive Output Leak

## What Was Broken
The `output "db_password"` block exposed `random_password.db.result` without `sensitive = true`.
This means the password would appear in plain text in:
- `terraform apply` CLI output
- `terraform output` CLI output
- Any CI/CD log that captures stdout

## The Fix
```hcl
output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
```

## What sensitive = true Does
- Redacts the value in CLI output (shows `<sensitive>`).
- Prevents the value from being shown in `terraform output` without `-json` or `-raw`.
- Marks the output as sensitive so downstream module callers cannot accidentally expose it.

## Note on State
`sensitive = true` does NOT encrypt the value in state. The value is still stored in plaintext
in `terraform.tfstate`. Use remote state with encryption (e.g., S3 + SSE, Terraform Cloud) to
protect secrets at rest.

## Why It Matters
Passwords in CLI output are logged by CI/CD systems, terminal history, and pipeline artifacts.
Marking outputs sensitive is a minimal but important first line of defence.
""",
        "common_mistakes": """\
# Common Mistakes

- **Thinking `sensitive = true` encrypts state** — it only redacts CLI output, not state.
- **Forgetting to mark downstream outputs** — if a module outputs a sensitive value and a root
  module outputs it without `sensitive = true`, the protection is lost.
- **Using `random_string` instead of `random_password`** — `random_password` marks `result`
  as sensitive by default; `random_string` does not.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — sensitive-in-locals
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_sensitive_in_locals():
    return {
        "module": MODULE,
        "slug": "level-2-sensitive-in-locals",
        "mission": {
            "name": "nonsensitive() Stripping Sensitivity",
            "description": "A `locals` block assigns a sensitive variable to a local. Terraform automatically propagates sensitivity through locals. However, the output wraps it in `nonsensitive()`, stripping the protection. Fix it by removing `nonsensitive()`.",
            "objective": "Remove `nonsensitive()` from the output so sensitivity is properly preserved and `terraform validate` passes.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["sensitive propagation in locals", "nonsensitive() misuse", "output sensitivity"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret"
}

locals {
  # Sensitivity propagates automatically from var.db_password to local.password
  password = var.db_password
}

# Broken: nonsensitive() strips the sensitivity — the value will be exposed in output
output "password" {
  value = nonsensitive(local.password)
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret"
}

locals {
  password = var.db_password
}

output "password" {
  value     = local.password
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The config validates but the output leaks sensitive data. Look for `nonsensitive()` in the output value.",
            "`nonsensitive()` is designed to explicitly opt-out of sensitivity when you're certain a value is safe to show. Using it on a password undoes all sensitivity protection.",
            "Remove `nonsensitive()` and add `sensitive = true` to the output block.",
        ],
        "debrief": """\
# nonsensitive() Stripping Sensitivity

## What Was Broken
`nonsensitive(local.password)` deliberately stripped the sensitive marking from a password.
Terraform then treated the output as non-sensitive and printed it to the terminal.

## How Sensitivity Propagates Through Locals
When a sensitive value is assigned to a `locals` block entry, Terraform automatically marks
that local as sensitive. No annotation is needed in `locals {}`:

```hcl
variable "secret" {
  sensitive = true
}

locals {
  derived = var.secret  # also sensitive — automatically
}
```

## When nonsensitive() Is Appropriate
`nonsensitive()` should only be used when you have **verified** the value has been transformed
to no longer contain sensitive data, for example:
```hcl
output "password_length" {
  value = nonsensitive(length(var.password))  # length is not sensitive
}
```

## Why It Matters
Misuse of `nonsensitive()` is a common way to accidentally bypass Terraform's sensitivity system.
Treat it like a security assertion: only use it when you can prove the value is safe to expose.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `nonsensitive()` to "fix" a validate error** — if Terraform complains about a sensitive
  value, the correct fix is usually to mark the output `sensitive = true`, not to call `nonsensitive()`.
- **Forgetting locals propagate sensitivity** — you do not need to annotate locals; it is automatic.
- **Using `nonsensitive()` on a whole object containing secrets** — this exposes every field.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — nonsensitive-override
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_nonsensitive_override():
    return {
        "module": MODULE,
        "slug": "level-3-nonsensitive-override",
        "mission": {
            "name": "Direct nonsensitive() on Secret Variable",
            "description": "The output directly wraps a sensitive variable in `nonsensitive()`, exposing it. Fix it: remove `nonsensitive()` and mark the output as `sensitive = true`.",
            "objective": "Remove `nonsensitive()` and add `sensitive = true` to the output so the secret is protected.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["nonsensitive() misuse", "sensitive output", "secret protection"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "secret" {
  type      = string
  sensitive = true
  default   = "top-secret-value"
}

# Broken: nonsensitive() directly on a sensitive variable exposes it
output "exposed_secret" {
  value = nonsensitive(var.secret)
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "secret" {
  type      = string
  sensitive = true
  default   = "top-secret-value"
}

output "exposed_secret" {
  value     = var.secret
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "The output wraps `var.secret` in `nonsensitive()`. This is the source of the leak — it explicitly removes the sensitive marking.",
            "`nonsensitive()` should only be called when the value is genuinely safe to expose. For a secret variable, it never is.",
            "Remove `nonsensitive()`, change `value = var.secret`, and add `sensitive = true` to the output block.",
        ],
        "debrief": """\
# Direct nonsensitive() on Secret Variable

## What Was Broken
`output "exposed_secret" { value = nonsensitive(var.secret) }` directly stripped the sensitive
marking from a secret variable. The raw value would be displayed in `terraform output`.

## The Correct Pattern
```hcl
output "exposed_secret" {
  value     = var.secret
  sensitive = true
}
```

## Security Principle: Least Privilege Output
Outputs should expose the minimum information necessary. If a downstream consumer needs to
*use* the secret (e.g., pass it to another module), mark the output `sensitive = true` so
it is protected end-to-end. If the downstream consumer does not need the value at all,
do not output it.

## Why nonsensitive() Exists
`nonsensitive()` is an escape hatch for situations where the sensitive marking was applied
too broadly. For example, if a function returns a sensitive value but you have already
sanitized it:
```hcl
output "sanitized" {
  # replace() with a redaction — the result is safe to show
  value = nonsensitive(replace(var.secret, "/./", "*"))
}
```

## Why It Matters
Every misuse of `nonsensitive()` is a potential credential leak in CI logs, plan files, and
terminal history. Code-review `nonsensitive()` calls as security-critical changes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `nonsensitive()` to silence "output refers to sensitive values" errors** — the right
  fix is `sensitive = true` on the output, not `nonsensitive()` on the value.
- **Applying `nonsensitive()` to objects that still contain secret fields**.
- **Forgetting that `nonsensitive()` is permanent for that reference** — once stripped, any
  module receiving the output sees it as non-sensitive.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — secret-in-tfvars
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_secret_in_tfvars():
    return {
        "module": MODULE,
        "slug": "level-4-secret-in-tfvars",
        "mission": {
            "name": "Secret in tfvars Exposed via Output",
            "description": "`terraform.tfvars` contains `db_password = \"supersecret123\"`. The config references it in a plain (non-sensitive) output, which will print the value. Fix: mark the output as `sensitive`.",
            "objective": "Add `sensitive = true` to the output so the secret from tfvars is redacted.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["tfvars secrets", "sensitive outputs", "variable files"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "db_password" {
  type = string
}

# Broken: plain output exposes the tfvars secret
output "db_password" {
  value = var.db_password
}
""",
            "terraform.tfvars": """\
db_password = "supersecret123"
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "db_password" {
  type      = string
  sensitive = true
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
""",
            "terraform.tfvars": """\
db_password = "supersecret123"
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "The variable `db_password` is loaded from `terraform.tfvars` at plan time. The output exposes it without `sensitive = true`.",
            "Mark the variable `sensitive = true` so Terraform knows to handle it carefully. Then mark the output `sensitive = true` as well.",
            "Add `sensitive = true` to both the `variable \"db_password\"` block and the `output \"db_password\"` block.",
        ],
        "debrief": """\
# Secret in tfvars Exposed via Output

## What Was Broken
The `db_password` variable held a secret from `terraform.tfvars` but was not marked `sensitive`.
The output then printed the value in plain text.

## Dual Sensitivity: Variable + Output
For full protection, mark sensitivity in both places:
```hcl
variable "db_password" {
  type      = string
  sensitive = true   # prevents value from appearing in plan/apply diffs
}

output "db_password" {
  value     = var.db_password
  sensitive = true   # redacts in CLI output
}
```

## tfvars Security Best Practices
- **Never commit `terraform.tfvars` containing secrets to version control**.
- Use `.gitignore` to exclude `*.tfvars` and `*.tfvars.json`.
- Use environment variables (`TF_VAR_db_password`) or secret managers as alternatives.
- Use `*.auto.tfvars` only for non-sensitive defaults.

## Why It Matters
`terraform.tfvars` is often the first place junior practitioners store secrets. Without `sensitive`
markings, those secrets flow through to outputs, logs, and CI artifacts.
""",
        "common_mistakes": """\
# Common Mistakes

- **Marking only the output, not the variable** — plan output can still show sensitive variable
  values in diffs if the variable itself is not marked sensitive.
- **Committing `terraform.tfvars` with real passwords** — use `.gitignore`.
- **Thinking `sensitive = true` on a variable removes the value from state** — it does not;
  state always contains the raw value.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — env-var-secret
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_env_var_secret():
    return {
        "module": MODULE,
        "slug": "level-5-env-var-secret",
        "mission": {
            "name": "Wrong Variable Name for TF_VAR_ Injection",
            "description": "The variable is named `DB_PASSWORD` (uppercase), but Terraform environment variable injection requires `TF_VAR_db_password` (lowercase). The name mismatch means the env var is never read. Fix: rename the variable to `db_password`.",
            "objective": "Rename the variable to `db_password` so it maps to the `TF_VAR_db_password` environment variable.",
            "xp": 225,
            "difficulty": "advanced",
            "expected_time": "15m",
            "concepts": ["TF_VAR_ naming convention", "environment variable injection", "variable naming"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# Variable name uses uppercase — env var TF_VAR_db_password won't map to this
variable "DB_PASSWORD" {
  type      = string
  sensitive = true
  default   = "fallback-password"
}

resource "local_file" "config" {
  content  = "password=${var.DB_PASSWORD}"
  filename = "${path.module}/app.conf"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "db_password" {
  type      = string
  sensitive = true
  default   = "fallback-password"
}

resource "local_file" "config" {
  content  = "password=${var.db_password}"
  filename = "${path.module}/app.conf"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Terraform maps `TF_VAR_<name>` environment variables to variables by their lowercase name. `TF_VAR_db_password` maps to `var.db_password`, not `var.DB_PASSWORD`.",
            "Variable names in HCL are case-sensitive. If you export `TF_VAR_db_password=mysecret` but the variable is named `DB_PASSWORD`, the env var is silently ignored.",
            "Rename the variable from `DB_PASSWORD` to `db_password` in both the `variable` block and anywhere it is referenced.",
        ],
        "debrief": """\
# Wrong Variable Name for TF_VAR_ Injection

## What Was Broken
The variable was named `DB_PASSWORD` (uppercase). Terraform's `TF_VAR_` mechanism uses the
environment variable name converted to lowercase to match the variable name. So
`TF_VAR_DB_PASSWORD` would work, but `TF_VAR_db_password` would not — and the latter is the
conventional form.

## TF_VAR_ Naming Rules
- The env var `TF_VAR_foo` maps to the variable `foo`.
- Variable names should be lowercase with underscores by convention.
- HCL identifiers are case-sensitive: `DB_PASSWORD` and `db_password` are different variables.

## Best Practice for Secrets via Environment Variables
```bash
export TF_VAR_db_password="my-secure-password"
terraform apply
```
This avoids storing secrets in files entirely. The secret lives only in the shell environment.

## Why It Matters
A mis-named variable silently falls back to the default value. If the default is a weak
placeholder, production systems might run with insecure credentials without any error.
""",
        "common_mistakes": """\
# Common Mistakes

- **Uppercase variable names** — use `snake_case` for all Terraform identifiers.
- **Relying on `TF_VAR_DB_PASSWORD` matching `var.db_password`** — casing must match exactly.
- **Setting `TF_VAR_` but forgetting `sensitive = true`** — the variable is still exposed in
  plan/apply output without the sensitive flag.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — secret-in-state
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_secret_in_state():
    return {
        "module": MODULE,
        "slug": "level-6-secret-in-state",
        "mission": {
            "name": "Password Written to Plaintext File",
            "description": "`random_password.db.result` is written to a `local_file` resource, creating a plaintext credentials file. Fix: use `local_sensitive_file` instead to enforce stricter file permissions.",
            "objective": "Replace `local_file` with `local_sensitive_file` so the credentials file is created with restrictive permissions.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["secrets in state", "local_sensitive_file", "file permissions"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length  = 24
  special = false
}

# Broken: writing the password to a world-readable local_file
resource "local_file" "credentials" {
  content  = "DB_PASSWORD=${random_password.db.result}"
  filename = "${path.module}/credentials.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length  = 24
  special = false
}

resource "local_sensitive_file" "credentials" {
  content  = "DB_PASSWORD=${random_password.db.result}"
  filename = "${path.module}/credentials.txt"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "The `local_file` resource creates files with default permissions (usually `0644`) — readable by everyone on the system.",
            "The `local` provider includes a `local_sensitive_file` resource specifically for writing secrets. It creates files with `0600` permissions (owner read/write only).",
            "Replace `resource \"local_file\"` with `resource \"local_sensitive_file\"`. The arguments are identical.",
        ],
        "debrief": """\
# Password Written to Plaintext File

## What Was Broken
`local_file` creates files with default permissions (typically `0644`) — readable by all users
on the system. Writing a password to such a file violates the principle of least-privilege access.

## local_sensitive_file vs local_file
| Resource               | Default permissions | Use for |
|------------------------|---------------------|---------|
| `local_file`           | `0644`              | Non-sensitive content |
| `local_sensitive_file` | `0600`              | Secrets, credentials, keys |

`local_sensitive_file` also marks its `content` attribute as sensitive, which prevents the
value from appearing in plan/apply output.

## A Note on State
Even with `local_sensitive_file`, the credential value is stored in `terraform.tfstate` in
plaintext. Protect state files with:
- Remote state with encryption (S3 + SSE, GCS + CMEK, Terraform Cloud).
- Access controls on the state backend.
- Never committing `terraform.tfstate` to version control.

## Why It Matters
A credentials file with `0644` permissions can be read by any user on a shared system. This
is a real-world attack vector on multi-user Linux hosts.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `local_file` for any secret** — always use `local_sensitive_file` for credentials.
- **Setting `file_permission = "0644"` on `local_sensitive_file`** — this overrides the default
  strict permissions and defeats the purpose.
- **Thinking file permissions protect secrets in a Docker container** — in containers, use
  environment variables or secrets managers instead of files.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — tls-cert-chain
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_tls_cert_chain():
    return {
        "module": MODULE,
        "slug": "level-7-tls-cert-chain",
        "mission": {
            "name": "Wrong ca_key_algorithm in TLS Cert Chain",
            "description": "`tls_locally_signed_cert` references `ca_key_algorithm = \"RSA\"` (a hardcoded string) instead of `tls_private_key.ca.algorithm`. Fix the reference.",
            "objective": "Replace the hardcoded string with the correct reference to `tls_private_key.ca.algorithm` so `terraform apply` succeeds.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["TLS chain", "resource references", "tls_locally_signed_cert"],
        },
        "broken": {
            "terraform.tf": LOCAL_TLS_TF,
            "main.tf": """\
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Example CA"
    organization = "Example Org"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Org"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  # Broken: hardcoded "RSA" string instead of referencing the CA key's algorithm
  ca_key_algorithm = "RSA"

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "server_cert_pem" {
  value     = tls_locally_signed_cert.server.cert_pem
  sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_TLS_TF,
            "main.tf": """\
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Example CA"
    organization = "Example Org"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Org"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  ca_key_algorithm = tls_private_key.ca.algorithm

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "server_cert_pem" {
  value     = tls_locally_signed_cert.server.cert_pem
  sensitive = true
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The `tls_locally_signed_cert` resource may fail or produce a mismatched cert chain if the algorithm is hardcoded and doesn't match the CA key.",
            "`tls_private_key` exports its `algorithm` attribute. Reference it dynamically to avoid drift if the algorithm ever changes.",
            "Change `ca_key_algorithm = \"RSA\"` to `ca_key_algorithm = tls_private_key.ca.algorithm`.",
        ],
        "debrief": """\
# Wrong ca_key_algorithm in TLS Cert Chain

## What Was Broken
`ca_key_algorithm = "RSA"` was hardcoded. While this happened to match the CA key, hardcoded
values create fragile configurations: if the CA key algorithm is changed to `ECDSA`, the
`tls_locally_signed_cert` resource would silently use the wrong algorithm.

## Dynamic Reference Pattern
```hcl
resource "tls_locally_signed_cert" "server" {
  ca_key_algorithm = tls_private_key.ca.algorithm  # always in sync with the CA key
  ...
}
```

## TLS Certificate Chain Components
1. `tls_private_key.ca` — CA private key
2. `tls_self_signed_cert.ca` — CA certificate (self-signed)
3. `tls_private_key.server` — server private key
4. `tls_cert_request.server` — certificate signing request (CSR)
5. `tls_locally_signed_cert.server` — server cert signed by the CA

## Why It Matters
Certificate chain errors cause TLS handshake failures that are notoriously difficult to debug.
Referencing resources dynamically ensures all parts of the chain stay consistent.
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding algorithm strings** — use resource attribute references so changes propagate.
- **Forgetting `is_ca_certificate = true` on the CA cert** — without it, the cert cannot sign.
- **Using too-short validity periods** — short-lived certs require frequent rotation automation.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — tls-cert-rotation
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_tls_cert_rotation():
    return {
        "module": MODULE,
        "slug": "level-8-tls-cert-rotation",
        "mission": {
            "name": "TLS Certificate Expiring Too Fast",
            "description": "`tls_self_signed_cert` with `validity_period_hours = 1` expires in one hour and `early_renewal_hours = 0` means no automatic renewal buffer. Fix: set `validity_period_hours = 8760` (1 year) and `early_renewal_hours = 168` (1 week).",
            "objective": "Set appropriate validity and early renewal hours so the cert is long-lived and will renew with enough lead time.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["cert rotation", "validity periods", "early_renewal_hours"],
        },
        "broken": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Org"
  }

  # Broken: expires in 1 hour, no early renewal buffer
  validity_period_hours = 1
  early_renewal_hours   = 0

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "cert_pem" {
  value     = tls_self_signed_cert.server.cert_pem
  sensitive = true
}
""",
        },
        "solution": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Org"
  }

  validity_period_hours = 8760   # 1 year
  early_renewal_hours   = 168    # renew 1 week before expiry

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "cert_pem" {
  value     = tls_self_signed_cert.server.cert_pem
  sensitive = true
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The config applies but produces a cert that expires in 1 hour — nearly immediately useless.",
            "`validity_period_hours` controls how long the certificate is valid. `early_renewal_hours` tells Terraform to replace the cert when it has fewer than N hours remaining.",
            "Set `validity_period_hours = 8760` (1 year = 365 * 24) and `early_renewal_hours = 168` (1 week = 7 * 24).",
        ],
        "debrief": """\
# TLS Certificate Expiring Too Fast

## What Was Broken
`validity_period_hours = 1` creates a cert that expires in one hour. `early_renewal_hours = 0`
means Terraform will not proactively renew it before expiry. Together, these settings guarantee
an outage on any service using this certificate.

## Recommended Values

| Use Case             | validity_period_hours | early_renewal_hours |
|----------------------|-----------------------|---------------------|
| Production server    | 8760 (1 year)         | 168 (1 week)        |
| Dev/test             | 2160 (90 days)        | 48 (2 days)         |
| Short-lived service  | 720 (30 days)         | 24 (1 day)          |

## How early_renewal_hours Works
When `terraform plan` or `terraform apply` runs and the cert has fewer than `early_renewal_hours`
remaining, Terraform marks it for replacement. This allows automated pipelines to renew certs
proactively before they expire.

## Why It Matters
An expired TLS certificate causes immediate service outages and browser security warnings.
Proper renewal windows ensure continuous service availability.
""",
        "common_mistakes": """\
# Common Mistakes

- **`early_renewal_hours = 0`** — no renewal buffer; certs will expire before replacement.
- **`validity_period_hours` too short** — test values (1h, 24h) accidentally left in production.
- **Not automating apply runs** — `early_renewal_hours` only triggers on `terraform plan/apply`;
  if Terraform is never run, certs will expire regardless of this setting.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — random-password-rotation
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_random_password_rotation():
    return {
        "module": MODULE,
        "slug": "level-9-random-password-rotation",
        "mission": {
            "name": "Password Forced to Rotate on Every Apply",
            "description": "The `random_password` resource has `keepers = { always_rotate = timestamp() }`. Because `timestamp()` changes on every plan, the password rotates on every apply. Fix: use a stable keeper value.",
            "objective": "Replace the volatile `timestamp()` keeper with a stable value so the password only rotates when intentionally triggered.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["keepers", "password rotation", "timestamp() side effects"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "app" {
  length  = 20
  special = true

  # Broken: timestamp() changes every plan — forces rotation on every apply
  keepers = {
    always_rotate = timestamp()
  }
}

resource "local_sensitive_file" "creds" {
  content  = "APP_PASSWORD=${random_password.app.result}"
  filename = "${path.module}/app-creds.txt"
}

output "password_set" {
  value = "Password has been set"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
variable "password_version" {
  type    = string
  default = "v1"
  description = "Increment this value to trigger password rotation."
}

resource "random_password" "app" {
  length  = 20
  special = true

  keepers = {
    version = var.password_version
  }
}

resource "local_sensitive_file" "creds" {
  content  = "APP_PASSWORD=${random_password.app.result}"
  filename = "${path.module}/app-creds.txt"
}

output "password_set" {
  value = "Password has been set"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform plan` twice in a row. You will see the `random_password` resource is planned for replacement every time because `timestamp()` changes.",
            "`keepers` is a map whose values are checked for changes to decide whether to regenerate the password. Using `timestamp()` means the keeper always changes.",
            "Replace the `timestamp()` keeper with a stable value — for example, a version variable that the operator increments only when rotation is desired.",
        ],
        "debrief": """\
# Password Forced to Rotate on Every Apply

## What Was Broken
`keepers = { always_rotate = timestamp() }` causes the password to be replaced on every
`terraform apply` because `timestamp()` returns a new value each time Terraform evaluates it.

## How keepers Work
`keepers` is a map. When any value in the map changes between runs, `random_password` generates
a new password. The idea is to tie password rotation to meaningful events:

```hcl
keepers = {
  version = var.password_version   # rotate by bumping the version variable
}
```

To force an immediate rotation, change `var.password_version` from `"v1"` to `"v2"`.

## Functions That Are Unstable in keepers
Avoid using these in `keepers` unless forced rotation is intentional:
- `timestamp()` — changes every plan
- `uuid()` — generates a new UUID every plan
- `plantimestamp()` — changes every plan

## Why It Matters
Uncontrolled password rotation means every `terraform apply` invalidates credentials across all
systems that use them. This causes outages and forces emergency credential rotations.
""",
        "common_mistakes": """\
# Common Mistakes

- **`timestamp()` in keepers** — almost always wrong; causes rotation on every apply.
- **No keepers at all** — password never rotates, even when it should.
- **Keepers tied to resource IDs that change** — if the resource is recreated, the keeper
  changes and triggers another password rotation.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — file-permissions
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_file_permissions():
    return {
        "module": MODULE,
        "slug": "level-10-file-permissions",
        "mission": {
            "name": "Overly Permissive File Permissions",
            "description": "`local_sensitive_file` is created with `file_permission = \"777\"`, which grants everyone on the system read, write, and execute access. Fix: set `file_permission = \"0600\"`.",
            "objective": "Change `file_permission` to `\"0600\"` so only the owner can read and write the file.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["file permissions", "octal strings", "local_sensitive_file"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "api_key" {
  length  = 32
  special = false
}

resource "local_sensitive_file" "api_key" {
  content  = random_password.api_key.result
  filename = "${path.module}/api_key.txt"

  # Broken: 777 allows anyone on the system to read, write, and execute this file
  file_permission = "777"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "api_key" {
  length  = 32
  special = false
}

resource "local_sensitive_file" "api_key" {
  content  = random_password.api_key.result
  filename = "${path.module}/api_key.txt"

  file_permission = "0600"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "`file_permission` is a string representing Unix permissions. `\"777\"` is world-readable/writable/executable — the most permissive possible setting.",
            "For secret files, `\"0600\"` (owner read/write, no access for group or others) is the correct permission. Some tools require `\"0400\"` (read-only) for key files.",
            "Change `file_permission = \"777\"` to `file_permission = \"0600\"`.",
        ],
        "debrief": """\
# Overly Permissive File Permissions

## What Was Broken
`file_permission = "777"` creates a file that any user on the system can read, modify, or
execute. For a secret file, this is equivalent to leaving your password printed on a public board.

## Unix Permission String Reference
| Octal String | Permissions |
|--------------|-------------|
| `"0600"`     | Owner: read+write. Group: none. Others: none. |
| `"0644"`     | Owner: read+write. Group: read. Others: read. |
| `"0400"`     | Owner: read. Group: none. Others: none. |
| `"0755"`     | Owner: read+write+exec. Group: read+exec. Others: read+exec. |
| `"0777"`     | Everyone: read+write+exec. Never use for secrets. |

## Octal String Format
Terraform expects a 4-digit octal string (e.g., `"0600"`). The leading zero is important —
it signals octal notation. Without it, `"600"` is parsed as decimal `600`, not octal `600`.

## Why It Matters
File permission errors are a common OWASP finding in security audits. Any process running
as another user on the same host can read `777` files, including container breakout scenarios.
""",
        "common_mistakes": """\
# Common Mistakes

- **`\"777\"` or `\"666\"` for secrets** — world-readable; never acceptable for credentials.
- **Omitting the leading zero** — `\"600\"` is decimal six hundred, not octal 0600. Use `\"0600\"`.
- **Using `\"0600\"` on files that daemons need to read** — if a non-owner process reads the
  file, use `\"0640\"` (group read) with appropriate group ownership.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — prevent-destroy-prod
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_prevent_destroy_prod():
    return {
        "module": MODULE,
        "slug": "level-11-prevent-destroy-prod",
        "mission": {
            "name": "Unconditional prevent_destroy Blocks All Environments",
            "description": "`prevent_destroy = true` is hardcoded, blocking destruction in every workspace including dev and test. Fix: use `terraform.workspace == \"production\"` so only the production workspace is protected.",
            "objective": "Make `prevent_destroy` conditional on the workspace so dev/test can be destroyed freely.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["conditional prevent_destroy", "lifecycle meta-argument", "workspace-aware config"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "db_config" {
  content  = "DATABASE_URL=postgres://prod-db:5432/app"
  filename = "${path.module}/db.conf"

  lifecycle {
    # Broken: hardcoded true blocks destruction in ALL workspaces, including dev
    prevent_destroy = true
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "db_config" {
  content  = "DATABASE_URL=postgres://prod-db:5432/app"
  filename = "${path.module}/db.conf"

  lifecycle {
    prevent_destroy = terraform.workspace == "production"
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The config is valid but `prevent_destroy = true` blocks destruction everywhere, which makes development workflows painful.",
            "`prevent_destroy` accepts a boolean expression, not just a literal. You can use `terraform.workspace` to conditionally enable it.",
            "Change `prevent_destroy = true` to `prevent_destroy = terraform.workspace == \"production\"`.",
        ],
        "debrief": """\
# Unconditional prevent_destroy Blocks All Environments

## What Was Broken
`prevent_destroy = true` was hardcoded. This protects production as intended but also prevents
destruction in `dev`, `staging`, and CI test workspaces, making cleanup impossible without
editing the config.

## Conditional prevent_destroy
```hcl
lifecycle {
  prevent_destroy = terraform.workspace == "production"
}
```
This evaluates to `true` only in the `production` workspace, and `false` in all others.

## What prevent_destroy Does
When set to `true`, any `terraform destroy` or plan that would destroy this resource will fail
with an error. It is a safety net against accidental deletion of critical infrastructure.

## Workspace-Aware Security Patterns
```hcl
locals {
  is_production = terraform.workspace == "production"
}

resource "local_file" "config" {
  ...
  lifecycle {
    prevent_destroy = local.is_production
  }
}
```

## Why It Matters
Hardcoded `prevent_destroy = true` in shared modules means all environments inherit the
protection, blocking legitimate dev/test teardown workflows.
""",
        "common_mistakes": """\
# Common Mistakes

- **`prevent_destroy = true` in shared modules** — child modules should let callers control
  this via a variable.
- **Relying solely on `prevent_destroy` for production safety** — combine with IAM policies,
  state locking, and change approval workflows.
- **`prevent_destroy = var.environment == "prod"`** — be careful with typos in the workspace
  or environment name; use `contains(["production", "prod"], terraform.workspace)` for flexibility.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — lifecycle-sensitive
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_lifecycle_sensitive():
    return {
        "module": MODULE,
        "slug": "level-12-lifecycle-sensitive",
        "mission": {
            "name": "ignore_changes Hiding Security Drift",
            "description": "`ignore_changes = [content]` is configured on a credentials file. If someone manually edits or corrupts the file content, Terraform will never detect or correct it. Remove `ignore_changes` for the security-critical `content` attribute.",
            "objective": "Remove `ignore_changes = [content]` so Terraform will detect and correct drift in the credentials file.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["ignore_changes security implications", "drift detection", "lifecycle meta-argument"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "service" {
  length  = 16
  special = false
}

resource "local_sensitive_file" "service_creds" {
  content  = random_password.service.result
  filename = "${path.module}/service.key"

  lifecycle {
    # Broken: ignoring content means Terraform will never fix a tampered credential file
    ignore_changes = [content]
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "service" {
  length  = 16
  special = false
}

resource "local_sensitive_file" "service_creds" {
  content  = random_password.service.result
  filename = "${path.module}/service.key"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Look at the `lifecycle` block. `ignore_changes = [content]` tells Terraform to never update the file content, even if it drifts from the expected value.",
            "For a credentials file, detecting and correcting content drift is a security requirement. An attacker who modifies the file would go undetected indefinitely.",
            "Remove the entire `lifecycle { ignore_changes = [content] }` block.",
        ],
        "debrief": """\
# ignore_changes Hiding Security Drift

## What Was Broken
`ignore_changes = [content]` told Terraform to never report or fix changes to the file content.
If an attacker or misconfiguration modified the credentials file, the next `terraform plan`
would show no changes — a false sense of security.

## When ignore_changes Is Appropriate
`ignore_changes` is legitimate when:
- An external process (not Terraform) intentionally manages an attribute.
- The attribute changes frequently and the changes are expected and correct.

It is **never** appropriate for security-critical attributes like credentials, keys, or
certificate content.

## Drift Detection as a Security Control
Regular `terraform plan` or `terraform apply` runs serve as a configuration audit:
- If Terraform shows changes, investigate *why* the live state differs from the desired state.
- Unexpected drift can indicate unauthorized changes or misconfiguration.

## Why It Matters
`ignore_changes` on security attributes creates a blind spot. Combining it with `prevent_destroy`
creates a resource that can be tampered with, and Terraform will never fix or flag it.
""",
        "common_mistakes": """\
# Common Mistakes

- **`ignore_changes = [all]`** — this is almost always wrong; it makes Terraform ignore all
  attribute drift for a resource.
- **Using `ignore_changes` to suppress noisy plan output** — fix the root cause instead.
- **Leaving `ignore_changes` in production configs from dev experiments** — review lifecycle
  blocks in code reviews for security resources.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — validation-security
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_validation_security():
    return {
        "module": MODULE,
        "slug": "level-13-validation-security",
        "mission": {
            "name": "Wrong Operator in Password Length Validation",
            "description": "The variable validation uses `condition = length(var.password) <= 8`, which accepts short passwords and rejects long ones — the opposite of a security requirement. Fix: change `<=` to `>=`.",
            "objective": "Correct the validation operator so passwords shorter than 8 characters are rejected.",
            "xp": 275,
            "difficulty": "advanced",
            "expected_time": "20m",
            "concepts": ["security validation", "variable validation", "password policy"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "password" {
  type      = string
  sensitive = true

  validation {
    # Broken: <= accepts short passwords and rejects long ones
    condition     = length(var.password) <= 8
    error_message = "Password must be at least 8 characters long."
  }
}

resource "local_sensitive_file" "password_file" {
  content  = var.password
  filename = "${path.module}/password.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "password" {
  type      = string
  sensitive = true

  validation {
    condition     = length(var.password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
}

resource "local_sensitive_file" "password_file" {
  content  = var.password
  filename = "${path.module}/password.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Read the validation error message: `\"Password must be at least 8 characters long.\"` Now look at the condition — does it match the message?",
            "The condition `length(var.password) <= 8` means: pass if the password has 8 or fewer characters. This is the opposite of a minimum-length requirement.",
            "Change `<=` to `>=` so the condition passes only when the password has at least 8 characters.",
        ],
        "debrief": """\
# Wrong Operator in Password Length Validation

## What Was Broken
The validation condition `length(var.password) <= 8` passes for short passwords (1-8 chars) and
rejects long passwords (9+ chars). This is the opposite of a security-enforcing minimum-length
rule.

## Correct Security Validation
```hcl
validation {
  condition     = length(var.password) >= 8
  error_message = "Password must be at least 8 characters long."
}
```

## Composing Multiple Validations
```hcl
validation {
  condition     = length(var.password) >= 12
  error_message = "Password must be at least 12 characters."
}

validation {
  condition     = can(regex("[A-Z]", var.password))
  error_message = "Password must contain at least one uppercase letter."
}

validation {
  condition     = can(regex("[0-9]", var.password))
  error_message = "Password must contain at least one digit."
}
```

## Why It Matters
A backwards validation silently accepts weak passwords and rejects strong ones. This is a
security-critical bug that can go unnoticed because the config "validates successfully."
""",
        "common_mistakes": """\
# Common Mistakes

- **`<=` vs `>=` confusion** — always read the error message and verify the condition matches it.
- **Not testing the validation** — run `terraform plan` with both valid and invalid inputs to
  confirm the validation fires in the right cases.
- **Validating only length** — real password policies also check character sets, dictionary
  words, and previous password history.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — precondition-policy
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_precondition_policy():
    return {
        "module": MODULE,
        "slug": "level-14-precondition-policy",
        "mission": {
            "name": "Precondition Blocks Production Deployment",
            "description": "A resource precondition uses `condition = var.env != \"production\"`, which blocks the resource from being created in production. The intention is to allow dev, staging, and production. Fix: use `contains([\"dev\",\"staging\",\"production\"], var.env)`.",
            "objective": "Fix the precondition so it allows valid environments including production.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["precondition security policy", "environment allow-list", "lifecycle precondition"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type    = string
  default = "dev"
}

resource "local_file" "policy" {
  content  = "environment=${var.env}"
  filename = "${path.module}/policy.conf"

  lifecycle {
    precondition {
      # Broken: this blocks production deployments
      condition     = var.env != "production"
      error_message = "Unsupported environment. Use dev, staging, or production."
    }
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "env" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.env)
    error_message = "Environment must be one of: dev, staging, production."
  }
}

resource "local_file" "policy" {
  content  = "environment=${var.env}"
  filename = "${path.module}/policy.conf"

  lifecycle {
    precondition {
      condition     = contains(["dev", "staging", "production"], var.env)
      error_message = "Unsupported environment. Use dev, staging, or production."
    }
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Try running `terraform plan -var=\"env=production\"`. The precondition fires and blocks the apply. Read the condition — it says `var.env != \"production\"`, which fails in production.",
            "The intention is to allow only known environments. Use `contains()` to check against an allowlist instead of a single inequality.",
            "Change the condition to `contains([\"dev\", \"staging\", \"production\"], var.env)`.",
        ],
        "debrief": """\
# Precondition Blocks Production Deployment

## What Was Broken
The precondition `condition = var.env != "production"` was intended to gate invalid environments,
but it accidentally blocked the most important environment: production.

## Allowlist vs Denylist
Security best practice prefers allowlists (explicitly allow known-good values) over denylists
(explicitly block known-bad values):

```hcl
# Denylist (fragile — needs updating for every new bad value)
condition = var.env != "prod" && var.env != "production" && var.env != "prd"

# Allowlist (robust — only allows explicitly approved values)
condition = contains(["dev", "staging", "production"], var.env)
```

## Precondition vs Variable Validation
Both are appropriate here; the solution uses both for defence in depth:
- **Variable validation** catches the problem at input time (before any plan).
- **Precondition** provides a safety net at resource apply time.

## Why It Matters
A backwards security policy is often worse than no policy — it blocks legitimate work while
providing no actual protection. Always test security checks against both valid and invalid inputs.
""",
        "common_mistakes": """\
# Common Mistakes

- **Negation logic errors** — `!= "production"` blocks production, not protects it.
- **Incomplete allowlists** — forgetting aliases (`"prod"`, `"prd"`, `"PRODUCTION"`) that operators
  might use.
- **Missing both variable validation and precondition** — use both for defence in depth in
  security-critical resources.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — postcondition-audit
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_postcondition_audit():
    return {
        "module": MODULE,
        "slug": "level-15-postcondition-audit",
        "mission": {
            "name": "Postcondition File Permission Mismatch",
            "description": "A postcondition asserts `self.file_permission == \"0644\"` but the resource creates the file with `file_permission = \"0600\"`. The postcondition will always fail. Fix: align the postcondition with the actual permission.",
            "objective": "Change the postcondition to check `\"0600\"` so it matches the resource and `terraform apply` succeeds.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["postcondition audit", "self reference", "file permissions"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "audit_key" {
  length  = 24
  special = false
}

resource "local_sensitive_file" "audit_credential" {
  content         = random_password.audit_key.result
  filename        = "${path.module}/audit.key"
  file_permission = "0600"

  lifecycle {
    postcondition {
      # Broken: checks for 0644 but the resource creates with 0600
      condition     = self.file_permission == "0644"
      error_message = "Audit credential file must have restrictive permissions."
    }
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "audit_key" {
  length  = 24
  special = false
}

resource "local_sensitive_file" "audit_credential" {
  content         = random_password.audit_key.result
  filename        = "${path.module}/audit.key"
  file_permission = "0600"

  lifecycle {
    postcondition {
      condition     = self.file_permission == "0600"
      error_message = "Audit credential file must have restrictive permissions (0600)."
    }
  }
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. It fails with the postcondition error. Check whether the postcondition matches the actual `file_permission` value set on the resource.",
            "The resource sets `file_permission = \"0600\"` but the postcondition checks for `\"0644\"`. These values don't match.",
            "Change the postcondition condition to `self.file_permission == \"0600\"` to match the actual permission.",
        ],
        "debrief": """\
# Postcondition File Permission Mismatch

## What Was Broken
The postcondition asserted `self.file_permission == "0644"`, but the resource set
`file_permission = "0600"`. Since `0600 != 0644`, the postcondition always failed.

## Postcondition as a Security Audit Gate
Postconditions are evaluated *after* apply and check the actual resulting state. They are
powerful for security auditing:

```hcl
lifecycle {
  postcondition {
    condition     = self.file_permission == "0600"
    error_message = "Credential file must not be world-readable. Got: ${self.file_permission}."
  }
}
```

If someone changes the `file_permission` to `"0644"`, the apply will fail with the postcondition
error — immediately catching the security regression.

## self Reference in Postconditions
Inside a `postcondition`, `self` refers to the resource's post-apply attributes, allowing you
to verify the actual deployed state rather than the planned state.

## Why It Matters
Postconditions act as automated security compliance checks. A mismatch between the intended
permission (`"0644"`) and the secure default (`"0600"`) would typically be a bug in the
postcondition, not in the resource.
""",
        "common_mistakes": """\
# Common Mistakes

- **Postcondition expected value doesn't match resource value** — always verify both are aligned.
- **Using precondition instead of postcondition for state checks** — use `postcondition` when
  you need to verify the *resulting* state after apply.
- **Forgetting `self.` prefix** — inside postcondition, resource attributes are accessed via `self`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — ephemeral-values
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_ephemeral_values():
    return {
        "module": MODULE,
        "slug": "level-16-ephemeral-values",
        "mission": {
            "name": "Sensitive Variable Passed Without Protection",
            "description": "A sensitive variable is passed into a `local_file` content (not `local_sensitive_file`), and the output does not mark it sensitive. The sensitive value leaks through the output. Fix both issues.",
            "objective": "Use `local_sensitive_file` and mark the output `sensitive = true` so the secret is fully protected.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["sensitive values handling", "local_sensitive_file", "sensitive output"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "api_token" {
  type      = string
  sensitive = true
  default   = "token-abc123-secret"
}

# Broken: local_file does not enforce restrictive permissions and exposes the token
resource "local_file" "token_file" {
  content  = var.api_token
  filename = "${path.module}/token.txt"
}

# Broken: output exposes the sensitive value without sensitive = true
output "token_location" {
  value = local_file.token_file.filename
}

output "token_preview" {
  value = var.api_token
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
variable "api_token" {
  type      = string
  sensitive = true
  default   = "token-abc123-secret"
}

resource "local_sensitive_file" "token_file" {
  content  = var.api_token
  filename = "${path.module}/token.txt"
}

output "token_location" {
  value = local_sensitive_file.token_file.filename
}

output "token_preview" {
  value     = var.api_token
  sensitive = true
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "There are two problems: (1) `local_file` is used instead of `local_sensitive_file` for a secret, and (2) `output \"token_preview\"` exposes the sensitive variable without `sensitive = true`.",
            "Replace `resource \"local_file\"` with `resource \"local_sensitive_file\"`. Update the `output \"token_location\"` reference accordingly.",
            "Add `sensitive = true` to `output \"token_preview\"` to prevent the token from being displayed.",
        ],
        "debrief": """\
# Sensitive Variable Passed Without Protection

## What Was Broken
Two separate issues combined to expose a sensitive API token:
1. `local_file` (world-readable) was used instead of `local_sensitive_file` (owner-only).
2. `output "token_preview"` exposed the sensitive variable without `sensitive = true`.

## Defence in Depth for Sensitive Values
Sensitive values need protection at every layer:

| Layer               | Protection |
|---------------------|------------|
| Variable declaration | `sensitive = true` |
| File storage         | `local_sensitive_file` with `"0600"` permissions |
| Output declaration   | `sensitive = true` |
| State storage        | Encrypted remote backend |

## Systematic Review Process
When reviewing configs that handle secrets, check:
1. Is every output that touches the secret marked `sensitive`?
2. Is every file that stores the secret using `local_sensitive_file`?
3. Is `nonsensitive()` used anywhere? If so, is it justified?
4. Is the secret stored in state? If yes, is state encrypted?

## Why It Matters
Sensitive values require end-to-end protection. A single unprotected output or world-readable
file can expose credentials that took significant effort to otherwise protect.
""",
        "common_mistakes": """\
# Common Mistakes

- **Protecting the variable but not the output** — both must be marked sensitive.
- **Using `local_file` for any secret** — always use `local_sensitive_file`.
- **Assuming `sensitive = true` on the variable automatically protects all downstream uses** —
  each output and file must be explicitly protected.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — state-backend-security
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_state_backend_security():
    return {
        "module": MODULE,
        "slug": "level-17-state-backend-security",
        "mission": {
            "name": "Hardcoded Secret in Backend Config Comment",
            "description": "The `terraform.tf` file contains a comment with a hardcoded access key `AKIAIOSFODNN7EXAMPLE`. Even in a comment, credentials in source control are a security violation. Remove the hardcoded credential from the config.",
            "objective": "Remove the hardcoded credential from the config file so no secret appears in source.",
            "xp": 300,
            "difficulty": "advanced",
            "expected_time": "22m",
            "concepts": ["backend credential security", "hardcoded secrets", "partial backend config"],
        },
        "broken": {
            "terraform.tf": """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Simulated partial backend config — DO NOT hardcode credentials here
  # access_key = "AKIAIOSFODNN7EXAMPLE"   # <-- SECURITY VIOLATION: secret in source
  # secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  backend "local" {
    path = "terraform.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "readme" {
  content  = "This config demonstrates backend credential security."
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

  # Backend credentials should be provided via environment variables:
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
  # Or via a -backend-config file excluded from source control.

  backend "local" {
    path = "terraform.tfstate"
  }
}
""",
            "main.tf": """\
resource "local_file" "readme" {
  content  = "This config demonstrates backend credential security."
  filename = "${path.module}/README.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Even commented-out credentials are a security violation. Version control history is permanent — once committed, credentials in comments can be recovered from git history.",
            "Backend credentials should never appear in `.tf` files. Use environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) or a separate `-backend-config` file excluded from source control.",
            "Remove the commented credential lines from `terraform.tf` and replace them with a comment explaining the correct approach.",
        ],
        "debrief": """\
# Hardcoded Secret in Backend Config Comment

## What Was Broken
A commented-out AWS access key and secret key appeared in `terraform.tf`. Even as comments,
credentials in source code are a serious security violation because:
- Git history is permanent — even if removed, they can be recovered.
- CI/CD systems log file contents.
- Developers clone repos to local machines, spreading the credentials.

## Correct Backend Credential Patterns

### Environment Variables (Recommended)
```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="..."
terraform init
```

### Partial Backend Config File (Never Committed)
```bash
# backend.hcl — add to .gitignore
access_key = "AKIAIOSFODNN7EXAMPLE"
secret_key = "..."
```
```bash
terraform init -backend-config=backend.hcl
```

### IAM Instance Profiles / OIDC (Best for CI)
Use cloud-native auth (EC2 instance profiles, ECS task roles, GitHub Actions OIDC) so
no static credentials are ever needed.

## Why It Matters
Hardcoded credentials in source control are one of the top causes of cloud account compromises.
Tools like `git-secrets`, `truffleHog`, and `detect-secrets` scan for them — use them in CI.
""",
        "common_mistakes": """\
# Common Mistakes

- **Commenting out credentials instead of deleting them** — comments are still in the file and
  in git history.
- **Using `-backend-config` files without adding them to `.gitignore`**.
- **Rotating credentials but not removing the old ones from git history** — use `git filter-repo`
  or BFG Repo Cleaner to purge history after a credential leak.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — write-only-attributes
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_write_only_attributes():
    return {
        "module": MODULE,
        "slug": "level-18-write-only-attributes",
        "mission": {
            "name": "Password Exposed via nonsensitive() to Plain File",
            "description": "`random_password.result` is wrapped in `nonsensitive()` and written to a `local_file`. Both issues must be fixed: remove `nonsensitive()` and use `local_sensitive_file`.",
            "objective": "Fix both the `nonsensitive()` misuse and the insecure file resource so the password is fully protected.",
            "xp": 325,
            "difficulty": "advanced",
            "expected_time": "25m",
            "concepts": ["write-only patterns", "sensitive handling", "nonsensitive() misuse"],
        },
        "broken": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Broken: nonsensitive() strips the sensitive marking, then written to a world-readable file
resource "local_file" "db_password" {
  content  = nonsensitive(random_password.db.result)
  filename = "${path.module}/db_password.txt"
}

output "password_file" {
  value = local_file.db_password.filename
}

output "password_check" {
  value = "Password length: ${nonsensitive(length(random_password.db.result))}"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_RANDOM_TF,
            "main.tf": """\
resource "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_sensitive_file" "db_password" {
  content  = random_password.db.result
  filename = "${path.module}/db_password.txt"
}

output "password_file" {
  value = local_sensitive_file.db_password.filename
}

output "password_check" {
  value = "Password length: ${nonsensitive(length(random_password.db.result))}"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "There are two problems: (1) `nonsensitive()` wraps the password to write it to a `local_file`, stripping all protection; (2) `local_file` creates a world-readable file.",
            "Remove `nonsensitive()` from the `content` attribute of the file resource. Then change `local_file` to `local_sensitive_file`.",
            "Note: the `output \"password_check\"` correctly uses `nonsensitive(length(...))` — the *length* of a password is not sensitive. Only the raw password value is. Leave that output as is.",
        ],
        "debrief": """\
# Password Exposed via nonsensitive() to Plain File

## What Was Broken
Two security mistakes compounded:
1. `nonsensitive(random_password.db.result)` stripped the sensitive marking from the password.
2. The stripped value was written to `local_file` — a world-readable file.

The result: a password that `random_password` correctly marked as sensitive was fully exposed
on disk in a permissive file.

## Legitimate nonsensitive() Use (Kept in Solution)
```hcl
output "password_check" {
  value = "Password length: ${nonsensitive(length(random_password.db.result))}"
}
```
Here, `nonsensitive()` is applied to the *length* of the password, not the password itself.
The length is not sensitive information — it's fine to display it.

## Write-Only Pattern for Credentials
The ideal pattern for writing credentials to disk:
```hcl
resource "local_sensitive_file" "db_password" {
  content         = random_password.db.result  # no nonsensitive() wrapper
  filename        = "${path.module}/db_password.txt"
  file_permission = "0600"
}
```

## End-to-End Sensitive Data Handling Checklist
- [ ] Variable: `sensitive = true`
- [ ] File resource: `local_sensitive_file`, not `local_file`
- [ ] No `nonsensitive()` on raw secret values
- [ ] Output: `sensitive = true` (or do not output the raw value)
- [ ] State: encrypted remote backend

## Why It Matters
`nonsensitive()` is the "override security" function. Every call to it should be reviewed as
a security decision. Wrapping a password in it to solve a type error is always wrong — use
`local_sensitive_file` or a secrets manager instead.
""",
        "common_mistakes": """\
# Common Mistakes

- **`nonsensitive(resource.attr)` to silence errors** — solve the root cause instead.
- **Forgetting to update references after changing `local_file` to `local_sensitive_file`** —
  the output references `local_file.db_password.filename`; update it to
  `local_sensitive_file.db_password.filename`.
- **Applying `nonsensitive()` to derived values containing the secret** — interpolations like
  `"prefix-${nonsensitive(var.secret)}-suffix"` still expose the raw secret.
""",
    }


if __name__ == "__main__":
    build()
