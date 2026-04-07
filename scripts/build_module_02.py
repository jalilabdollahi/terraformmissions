#!/usr/bin/env python3
"""Module 2 — Resource Basics (20 levels, Beginner)."""
from __future__ import annotations

from scripts.build_utils import (
    DEFAULT_TERRAFORM_TF,
    LOCAL_ONLY_TF,
    NULL_ONLY_TF,
    RANDOM_ONLY_TF,
    TLS_ONLY_TF,
    print_done,
    validate_tf_apply,
    validate_tf_validate,
    validate_custom,
    write_level,
)

MODULE = "module-2-resource-basics"


def build() -> int:
    levels = [
        _level_01_local_file_create(),
        _level_02_local_file_content(),
        _level_03_local_sensitive_file(),
        _level_04_random_string_length(),
        _level_05_random_string_special(),
        _level_06_random_integer(),
        _level_07_random_password(),
        _level_08_random_uuid(),
        _level_09_random_pet(),
        _level_10_null_resource_trigger(),
        _level_11_null_provisioner(),
        _level_12_tls_private_key(),
        _level_13_tls_self_signed(),
        _level_14_tls_cert_request(),
        _level_15_resource_reference(),
        _level_16_implicit_dependency(),
        _level_17_explicit_depends_on(),
        _level_18_resource_timeout(),
        _level_19_lifecycle_prevent_destroy(),
        _level_20_lifecycle_ignore_changes(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — local-file-create
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_local_file_create():
    return {
        "module": MODULE,
        "slug": "level-1-local-file-create",
        "mission": {
            "name": "The Unreachable Path",
            "description": (
                "A `local_file` resource points its `filename` at a deeply nested directory "
                "`/tmp/nonexistent/dir/config.txt` that Terraform will not create automatically. "
                "The apply fails because the parent directories do not exist."
            ),
            "objective": "Fix the `filename` attribute so `terraform apply` succeeds.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["local_file", "filename", "path.module"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The filename points to a path whose parent directories don't exist.
# Terraform's local_file provider will not create intermediate directories.

resource "local_file" "config" {
  content  = "environment = production"
  filename = "/tmp/nonexistent/dir/config.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "environment = production"
  filename = "${path.module}/config.txt"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply` and read the error carefully. Terraform reports it cannot write to the path because the parent directory does not exist.",
            "The `local_file` resource writes a single file — it does NOT create missing parent directories. Use a path whose parent directory already exists.",
            "Replace `/tmp/nonexistent/dir/config.txt` with `\"${path.module}/config.txt\"`. `path.module` resolves to the directory containing your `.tf` files, which always exists.",
        ],
        "debrief": """\
# The Unreachable Path

## What Was Broken
The `filename` attribute pointed to `/tmp/nonexistent/dir/config.txt`. The `local_file` provider
writes the file directly — it does **not** create intermediate parent directories. Because
`/tmp/nonexistent/dir/` does not exist, the write fails at apply time.

## The Fix
Use `path.module` to write the file into the module directory, which always exists:

```hcl
filename = "${path.module}/config.txt"
```

## Key Concept: `path.module`
Terraform exposes several built-in path references:

| Reference      | Resolves to |
|---------------|-------------|
| `path.module` | Directory of the current `.tf` file |
| `path.root`   | Root module directory |
| `path.cwd`    | Current working directory |

## Why It Matters
Hardcoding absolute paths like `/tmp/...` is fragile — it breaks across machines and CI environments.
Prefer `path.module`-relative paths for portability.
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding `/tmp/` paths with non-existent parents** — intermediate directories are not created automatically.
- **Expecting `local_file` to `mkdir -p`** — it does not; only the file itself is created.
- **Confusing `path.root` with `path.module`** — for single-module configs they are the same, but they differ when using child modules.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — local-file-content
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_local_file_content():
    return {
        "module": MODULE,
        "slug": "level-2-local-file-content",
        "mission": {
            "name": "Base64 or Bust",
            "description": (
                "A `local_file` resource uses `content_base64` with a plain text string instead of "
                "a properly base64-encoded value. This causes an apply-time error."
            ),
            "objective": "Fix the resource so it uses the correct attribute for plain text content.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["content", "content_base64", "local_file attributes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: content_base64 expects a valid base64-encoded string, not plain text.
# Using a plain string here causes an apply-time error.

resource "local_file" "readme" {
  content_base64 = "Hello, Terraform!"
  filename       = "${path.module}/readme.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "readme" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/readme.txt"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error says the value for `content_base64` is not valid base64.",
            "The `local_file` resource has two mutually exclusive content attributes: `content` (plain text) and `content_base64` (base64-encoded binary data). Only one may be set.",
            "Replace `content_base64 = \"Hello, Terraform!\"` with `content = \"Hello, Terraform!\"`.",
        ],
        "debrief": """\
# Base64 or Bust

## What Was Broken
`content_base64` accepts a **base64-encoded** string representing binary data. Passing raw plain text
like `"Hello, Terraform!"` is not valid base64, so the provider rejects it at apply time.

## The Fix
Use the `content` attribute for human-readable text:

```hcl
resource "local_file" "readme" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/readme.txt"
}
```

## `local_file` Content Attributes

| Attribute        | Use when |
|-----------------|----------|
| `content`        | Writing plain text (UTF-8) |
| `content_base64` | Writing binary data encoded as base64 |
| `source`         | Copying an existing file from disk |

These three attributes are **mutually exclusive** — you must use exactly one.

## Why It Matters
Providers often expose multiple ways to supply the same conceptual value (text vs binary vs file path).
Choosing the wrong one produces confusing errors that only appear at apply time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing `content` and `content_base64`** — only one may be set at a time.
- **Forgetting `source`** — if you already have a file on disk, use `source` instead of reading it yourself.
- **Confusing base64 encoding with encryption** — base64 is encoding, not encryption; sensitive data must still be handled carefully.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — local-sensitive-file
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_local_sensitive_file():
    return {
        "module": MODULE,
        "slug": "level-3-local-sensitive-file",
        "mission": {
            "name": "Permission Denied by Design",
            "description": (
                "A `local_sensitive_file` resource is declared without the required `file_permission` attribute. "
                "`terraform validate` reports a missing required argument."
            ),
            "objective": "Add the missing `file_permission` attribute so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["local_sensitive_file", "file_permission"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: local_sensitive_file requires file_permission to be set explicitly.
# The attribute is missing from this resource block.

resource "local_sensitive_file" "secret" {
  content  = "super-secret-api-key=abc123"
  filename = "${path.module}/secret.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_sensitive_file" "secret" {
  content         = "super-secret-api-key=abc123"
  filename        = "${path.module}/secret.txt"
  file_permission = "0600"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. Note which attribute the error says is missing.",
            "`local_sensitive_file` is designed for secrets. It requires you to explicitly declare file permissions to prevent accidental world-readable files.",
            "Add `file_permission = \"0600\"` to the resource block. `0600` means owner read/write only — no access for group or others.",
        ],
        "debrief": """\
# Permission Denied by Design

## What Was Broken
`local_sensitive_file` requires the `file_permission` argument. Unlike `local_file`, this resource
forces you to think about file security — it will not let you forget to set permissions.

## The Fix
```hcl
resource "local_sensitive_file" "secret" {
  content         = "super-secret-api-key=abc123"
  filename        = "${path.module}/secret.txt"
  file_permission = "0600"
}
```

## Understanding Unix File Permissions

| Permission | Meaning |
|-----------|---------|
| `0600`    | Owner read + write only (recommended for secrets) |
| `0640`    | Owner read+write, group read |
| `0644`    | Owner read+write, group+others read |

For secret files, always use `0600` to prevent other users from reading sensitive data.

## `local_sensitive_file` vs `local_file`
- `local_sensitive_file`: marks content as sensitive (hidden in plan output), requires explicit permissions
- `local_file`: general purpose, content visible in plan output

## Why It Matters
Secret files with wrong permissions are a common security vulnerability. Terraform enforces best
practices by making `file_permission` required on `local_sensitive_file`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `local_file` for secrets** — prefer `local_sensitive_file` so content is masked in plan output.
- **Using string `"600"` instead of octal `"0600"`** — always include the leading zero for octal notation.
- **Setting `0777` permissions on secret files** — this makes them world-readable by all users.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — random-string-length
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_random_string_length():
    return {
        "module": MODULE,
        "slug": "level-4-random-string-length",
        "mission": {
            "name": "Zero is Nothing",
            "description": (
                "A `random_string` resource has `length = 0`, which is invalid. "
                "The minimum allowed length is 1."
            ),
            "objective": "Fix the `length` attribute so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["random_string", "length constraint"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: length = 0 is invalid. The minimum value for length is 1.

resource "random_string" "token" {
  length  = 0
  special = false
  upper   = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
  upper   = false
}

output "token" {
  value = random_string.token.result
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error mentions a constraint violation on the `length` attribute.",
            "A random string of length zero produces nothing — the provider enforces a minimum of 1.",
            "Change `length = 0` to a positive integer like `length = 16`.",
        ],
        "debrief": """\
# Zero is Nothing

## What Was Broken
`random_string` enforces that `length` must be at least 1. Setting `length = 0` violates this
constraint and causes `terraform validate` to fail immediately.

## The Fix
```hcl
resource "random_string" "token" {
  length  = 16
  special = false
  upper   = false
}
```

## `random_string` Common Attributes

| Attribute          | Default | Description |
|-------------------|---------|-------------|
| `length`           | required | Number of characters (minimum: 1) |
| `upper`            | true    | Include uppercase letters |
| `lower`            | true    | Include lowercase letters |
| `numeric`          | true    | Include digits |
| `special`          | true    | Include special characters |
| `override_special` | `""`    | Limit special chars to this set |

## Why It Matters
Validation constraints catch impossible configurations before any API calls are made. Understanding
provider-enforced minimum/maximum constraints saves debugging time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Setting `length = 0`** — invalid; minimum is 1.
- **Using very short lengths for security tokens** — use at least 16 characters for tokens, 32+ for secrets.
- **Forgetting that `random_string.result` is stored in state** — it will be regenerated if you destroy and re-apply, potentially breaking things that depend on its stability.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — random-string-special
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_random_string_special():
    return {
        "module": MODULE,
        "slug": "level-5-random-string-special",
        "mission": {
            "name": "Special Characters Gone Wrong",
            "description": (
                "A `random_string` resource sets `special = true` and `override_special = \"\"` "
                "(an empty string). This forces special characters to come from an empty set, "
                "causing an apply-time error."
            ),
            "objective": "Fix `override_special` so that `terraform apply` succeeds.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["random_string", "override_special"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: special = true but override_special = "" means special chars must come
# from an empty set — impossible, causing an error at apply time.

resource "random_string" "password" {
  length           = 12
  special          = true
  override_special = ""
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_string" "password" {
  length           = 12
  special          = true
  override_special = "!@#$%"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error is about `override_special` being set to an empty string while `special = true`.",
            "`override_special` restricts which special characters can appear. If it is empty and `special = true`, there are no valid special characters to pick from — a contradiction.",
            "Either remove `override_special` entirely (uses the provider default set) or set it to a non-empty string like `\"!@#$%\"`.",
        ],
        "debrief": """\
# Special Characters Gone Wrong

## What Was Broken
`override_special = ""` tells the provider to use an empty set of special characters. Combined
with `special = true`, this is a contradiction — the resource must include special characters
but has no characters to choose from.

## The Fix
Provide a non-empty string for `override_special`:

```hcl
override_special = "!@#$%"
```

Or remove `override_special` entirely to use the provider's default special character set.

## How `override_special` Works
- When **not set**: uses the provider's default set (`!@#$%^&*()_+-=[]{}|;':,./<>?`)
- When **set to a non-empty string**: restricts special chars to only the listed characters
- When **set to `""`**: produces an empty set — incompatible with `special = true`

## Why It Matters
The interaction between `special` and `override_special` is subtle. Understanding how provider
arguments interact helps you avoid confusing runtime errors.
""",
        "common_mistakes": """\
# Common Mistakes

- **Setting `override_special = ""` with `special = true`** — empty override + special required is contradictory.
- **Including characters incompatible with your target system** — some systems reject certain special chars in passwords.
- **Forgetting that `override_special` has no effect when `special = false`** — enable `special = true` first.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — random-integer
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_random_integer():
    return {
        "module": MODULE,
        "slug": "level-6-random-integer",
        "mission": {
            "name": "Min Greater Than Max",
            "description": (
                "A `random_integer` resource has `min = 100` and `max = 10`. "
                "The minimum value is greater than the maximum, which is invalid."
            ),
            "objective": "Swap `min` and `max` so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["random_integer", "min", "max"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: min (100) is greater than max (10), which is logically impossible.

resource "random_integer" "port" {
  min = 100
  max = 10
}

output "port" {
  value = random_integer.port.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_integer" "port" {
  min = 10
  max = 100
}

output "port" {
  value = random_integer.port.result
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error describes a constraint violation on `min` and `max`.",
            "A range where the minimum is larger than the maximum is mathematically impossible. Think about which value should be smaller.",
            "Swap the values: set `min = 10` and `max = 100`.",
        ],
        "debrief": """\
# Min Greater Than Max

## What Was Broken
`random_integer` requires `min <= max`. When `min = 100` and `max = 10`, no integer satisfies
`100 <= x <= 10`, so the provider correctly rejects the configuration.

## The Fix
```hcl
resource "random_integer" "port" {
  min = 10
  max = 100
}
```

## `random_integer` Attributes

| Attribute | Required | Description |
|----------|----------|-------------|
| `min`    | yes      | Minimum value (inclusive) |
| `max`    | yes      | Maximum value (inclusive) |
| `seed`   | no       | Seed string for reproducible results |
| `keepers`| no       | Map of values that trigger regeneration |

The `result` attribute holds the generated integer.

## Why It Matters
Range validation (`min <= max`) is a common constraint across many resources and programming contexts.
Recognizing this class of error quickly saves debugging time.
""",
        "common_mistakes": """\
# Common Mistakes

- **Reversing `min` and `max`** — always ensure min is the smaller value.
- **Using `random_integer` for port numbers without checking valid ranges** — valid TCP/UDP ports are 1–65535.
- **Forgetting `keepers`** — without keepers, the integer only regenerates when the resource is replaced.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — random-password
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_random_password():
    return {
        "module": MODULE,
        "slug": "level-7-random-password",
        "mission": {
            "name": "More Than the Sum of Its Parts",
            "description": (
                "A `random_password` resource has `length = 5` but `min_upper = 2`, "
                "`min_lower = 2`, `min_numeric = 2`. The sum of minimums (6) exceeds the total "
                "length (5), which is impossible to satisfy."
            ),
            "objective": "Increase `length` so `terraform apply` succeeds.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["random_password", "length constraints"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: sum of minimums (2+2+2=6) exceeds length (5) — impossible to satisfy.

resource "random_password" "db_pass" {
  length      = 5
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_password" "db_pass" {
  length      = 10
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error message mentions that the sum of minimum character counts exceeds the total length.",
            "Add up: `min_upper` (2) + `min_lower` (2) + `min_numeric` (2) = 6. But `length` is only 5. It is one character short.",
            "Increase `length` to at least 6 — but use a realistic password length like 10 or 16 in production.",
        ],
        "debrief": """\
# More Than the Sum of Its Parts

## What Was Broken
The individual minimum character-class requirements totaled more than the password length:

```
min_upper (2) + min_lower (2) + min_numeric (2) = 6 > length (5)
```

The provider cannot construct a password that satisfies all constraints simultaneously.

## The Fix
Increase `length` to be at least the sum of all minimums:

```hcl
resource "random_password" "db_pass" {
  length      = 10
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
```

## Minimum Character Attributes

| Attribute      | Description |
|---------------|-------------|
| `min_upper`   | Minimum uppercase letters |
| `min_lower`   | Minimum lowercase letters |
| `min_numeric` | Minimum digit characters |
| `min_special` | Minimum special characters |

**Rule:** `min_upper + min_lower + min_numeric + min_special <= length`

## Why It Matters
This constraint is easy to overlook when requirements grow over time. Keep a running total of all
`min_*` values when setting `length`.
""",
        "common_mistakes": """\
# Common Mistakes

- **Not accounting for all `min_*` fields when setting `length`** — add them all up before choosing a length.
- **Forgetting `min_special`** — if `special = true` (default), also include `min_special` in the sum.
- **Outputting `random_password.result` without `sensitive = true`** — the result is marked sensitive and should stay that way.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — random-uuid
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_random_uuid():
    return {
        "module": MODULE,
        "slug": "level-8-random-uuid",
        "mission": {
            "name": "UUID Got the Wrong Attribute",
            "description": (
                "An output references `random_uuid.app_id.result`, but `random_uuid` does not have "
                "a `result` attribute. The correct attribute is `id`."
            ),
            "objective": "Fix the output reference so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["random_uuid", "resource attributes"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_uuid" "app_id" {}

# BUG: random_uuid exposes the UUID as .id, not .result
output "app_id" {
  value = random_uuid.app_id.result
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_uuid" "app_id" {}

output "app_id" {
  value = random_uuid.app_id.id
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `random_uuid.app_id` has no attribute named `result`.",
            "Different `random_*` resources expose their generated value through different attribute names. `random_string` uses `.result`, but `random_uuid` does not.",
            "Change `.result` to `.id`. The generated UUID is exposed as `random_uuid.<name>.id`.",
        ],
        "debrief": """\
# UUID Got the Wrong Attribute

## What Was Broken
`random_uuid` exposes the generated UUID through `.id`, not `.result`. The output was referencing
a non-existent `.result` attribute.

## The Fix
```hcl
output "app_id" {
  value = random_uuid.app_id.id
}
```

## Random Resource Attribute Reference

| Resource          | Generated value attribute |
|------------------|--------------------------|
| `random_string`   | `.result`                |
| `random_password` | `.result`                |
| `random_integer`  | `.result`                |
| `random_pet`      | `.id`                    |
| `random_uuid`     | `.id`                    |
| `random_id`       | `.hex`, `.dec`, `.b64_url`, `.b64_std` |

## Why It Matters
Each resource exposes its generated value under a specific attribute name. Checking the provider
documentation (or running `terraform providers schema`) prevents this class of error.
""",
        "common_mistakes": """\
# Common Mistakes

- **Assuming all `random_*` resources use `.result`** — `random_uuid` and `random_pet` use `.id`.
- **Confusing `random_id` with `random_uuid`** — `random_id` provides multiple encoding formats; `random_uuid` only has `.id`.
- **Not checking provider docs** — always verify attribute names before referencing them.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — random-pet
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_random_pet():
    return {
        "module": MODULE,
        "slug": "level-9-random-pet",
        "mission": {
            "name": "A Number is Not a Separator",
            "description": (
                "A `random_pet` resource has `separator = 123` — a number instead of a string. "
                "HCL type checking catches this mismatch."
            ),
            "objective": "Fix the `separator` attribute type so `terraform validate` passes.",
            "xp": 100,
            "difficulty": "beginner",
            "expected_time": "5m",
            "concepts": ["random_pet", "attribute types"],
        },
        "broken": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
# BUG: separator expects a string, not a number.

resource "random_pet" "server_name" {
  length    = 2
  separator = 123
}

output "server_name" {
  value = random_pet.server_name.id
}
""",
        },
        "solution": {
            "terraform.tf": RANDOM_ONLY_TF,
            "main.tf": """\
resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

output "server_name" {
  value = random_pet.server_name.id
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error reports a type mismatch on the `separator` attribute.",
            "The `separator` attribute expects a `string`. Numbers in HCL are written without quotes; strings require double quotes.",
            "Change `separator = 123` to `separator = \"-\"`.",
        ],
        "debrief": """\
# A Number is Not a Separator

## What Was Broken
`separator` is a `string` attribute. In HCL, `123` (no quotes) is a number literal. Terraform's
type system detects the mismatch and reports an error during validate.

## The Fix
```hcl
separator = "-"
```

## HCL Primitive Type Literals

| Type   | Example              |
|--------|---------------------|
| string | `"hello"`, `"-"`    |
| number | `42`, `3.14`        |
| bool   | `true`, `false`     |

Always use double quotes for string values.

## Why It Matters
Type mismatches between number literals and string attributes are a common beginner mistake in HCL.
The distinction between `"123"` (string) and `123` (number) matters. Terraform's type checker catches
these at validate time — before any resources are created.
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting quotes around string values** — `separator = -` (bare) and `separator = 123` (number) are both wrong.
- **Single quotes** — HCL only accepts double quotes for string literals.
- **Confusing `length` (number) with `separator` (string)** — each attribute has a defined type; check the docs.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — null-resource-trigger
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_null_resource_trigger():
    return {
        "module": MODULE,
        "slug": "level-10-null-resource-trigger",
        "mission": {
            "name": "Triggers Expect Strings",
            "description": (
                "A `null_resource` uses `triggers = { version = 1 }` with a number value. "
                "`triggers` is typed as `map(string)`, so all values must be strings."
            ),
            "objective": "Fix the `triggers` map so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["null_resource", "triggers", "map(string)"],
        },
        "broken": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
# BUG: triggers values must be strings. The number 1 must be quoted.

resource "null_resource" "deploy" {
  triggers = {
    version = 1
  }
}
""",
        },
        "solution": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
resource "null_resource" "deploy" {
  triggers = {
    version = "1"
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the value for `version` is a number but a string is required.",
            "`null_resource.triggers` is typed as `map(string)`. Every value in the map must be a string — even if it looks like a number.",
            "Change `version = 1` to `version = \"1\"` — wrap the number in double quotes to make it a string.",
        ],
        "debrief": """\
# Triggers Expect Strings

## What Was Broken
`triggers` on `null_resource` has type `map(string)`. Providing `version = 1` (an unquoted number)
violates this type constraint.

## The Fix
```hcl
triggers = {
  version = "1"
}
```

## How `triggers` Work
`null_resource` re-runs its provisioners whenever any trigger value changes. Common patterns:

```hcl
triggers = {
  version     = var.app_version          # string variable
  script_hash = filemd5("deploy.sh")     # re-run when script changes
}
```

All values are stored as strings in the state file, so Terraform enforces `map(string)`.

## Why It Matters
`map(string)` vs `map(any)` is a distinction that appears throughout Terraform. When a type is
constrained, all values must conform — including numeric-looking values.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using unquoted numbers in `map(string)`** — always quote numbers when used as map values.
- **Using `timestamp()` as a trigger carelessly** — this forces replacement on every single plan.
- **Expecting `null_resource` to produce meaningful outputs** — it has no computed attributes besides `id` and `triggers`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — null-provisioner
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_null_provisioner():
    return {
        "module": MODULE,
        "slug": "level-11-null-provisioner",
        "mission": {
            "name": "Echoo is Not a Command",
            "description": (
                "A `null_resource` provisioner runs `echoo hello` — a typo in the shell command. "
                "The provisioner fails at apply time because `echoo` is not a valid command."
            ),
            "objective": "Fix the typo in the provisioner command so `terraform apply` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["local-exec", "provisioner", "null_resource"],
        },
        "broken": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
# BUG: "echoo" is a typo — the correct command is "echo".

resource "null_resource" "greeting" {
  provisioner "local-exec" {
    command = "echoo hello"
  }
}
""",
        },
        "solution": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
resource "null_resource" "greeting" {
  provisioner "local-exec" {
    command = "echo hello"
  }
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error shows the provisioner exited with a non-zero status. Look at the exact command being run.",
            "The command `echoo` does not exist on most systems — it is a typo of the shell built-in `echo`.",
            "Change `command = \"echoo hello\"` to `command = \"echo hello\"`.",
        ],
        "debrief": """\
# Echoo is Not a Command

## What Was Broken
`provisioner "local-exec"` runs a shell command on the machine where Terraform is executing.
`echoo` is not a valid shell command (it is a typo of `echo`), so the shell returns a non-zero
exit code, which Terraform treats as a provisioner failure.

## The Fix
```hcl
provisioner "local-exec" {
  command = "echo hello"
}
```

## How `local-exec` Works
- The command runs on the **Terraform runner's machine** — not a remote server
- A non-zero exit code causes the provisioner to **fail**
- Provisioner failures cause `terraform apply` to fail and mark the resource as **tainted**

## Important Notes on Provisioners
Provisioners are a **last resort** in Terraform:
1. Use native provider resources when possible
2. Use `user_data` / `cloud-init` scripts for cloud VM initialization
3. Use configuration management tools (Ansible, Chef, Puppet) for complex setups

## Why It Matters
Shell command typos are caught only at runtime, not at validate time. Always test provisioner
commands independently in a shell before embedding them in Terraform.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in shell commands** — validate commands manually before embedding them in provisioners.
- **Forgetting that `local-exec` runs on the Terraform host** — not on the resource being created.
- **Not handling non-zero exit codes** — use `|| true` to ignore failures only when explicitly acceptable.
- **Relying on provisioners for idempotency** — provisioners do not re-run unless the resource is tainted or triggers change.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — tls-private-key
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_tls_private_key():
    return {
        "module": MODULE,
        "slug": "level-12-tls-private-key",
        "mission": {
            "name": "DSA is Not Supported",
            "description": (
                "A `tls_private_key` resource uses `algorithm = \"DSA\"`, which is not supported. "
                "Only RSA, ECDSA, and ED25519 are valid algorithms."
            ),
            "objective": "Fix the `algorithm` attribute so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["tls_private_key", "algorithm"],
        },
        "broken": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
# BUG: DSA is not a supported algorithm. Use RSA, ECDSA, or ED25519.

resource "tls_private_key" "server_key" {
  algorithm = "DSA"
}
""",
        },
        "solution": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error lists the valid values for `algorithm`.",
            "The `tls` provider supports only three algorithms: RSA, ECDSA, and ED25519. DSA is a legacy algorithm and is not implemented.",
            "Change `algorithm = \"DSA\"` to `algorithm = \"RSA\"` and optionally add `rsa_bits = 2048`.",
        ],
        "debrief": """\
# DSA is Not Supported

## What Was Broken
`tls_private_key` only supports three key algorithms:
- `RSA` — classic, widely supported, configurable key size
- `ECDSA` — elliptic curve, smaller keys with equivalent security
- `ED25519` — modern, fast, fixed key size

`DSA` is a legacy algorithm and is not implemented in the HashiCorp TLS provider.

## The Fix
```hcl
resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
```

## Algorithm Comparison

| Algorithm | Key Size     | Use Case |
|----------|-------------|---------|
| `RSA`    | 2048+ bits  | Broad compatibility |
| `ECDSA`  | 256/384/521 bits | TLS, code signing |
| `ED25519`| Fixed 256 bits | SSH keys, modern TLS |

## Why It Matters
Enum-like string arguments require exact values from an allowed list. The provider validates the
string during `terraform validate`. Always check documentation for the list of accepted values.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `DSA` or `RSA-PSS`** — only RSA, ECDSA, and ED25519 are supported.
- **Not setting `rsa_bits` for RSA** — defaults to 2048; consider 4096 for long-lived certificates.
- **Storing private keys in outputs without `sensitive = true`** — private keys must be kept secret.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — tls-self-signed
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_tls_self_signed():
    return {
        "module": MODULE,
        "slug": "level-13-tls-self-signed",
        "mission": {
            "name": "Negative Time Makes No Sense",
            "description": (
                "A `tls_self_signed_cert` resource has `validity_period_hours = -1`. "
                "A certificate cannot have a negative validity period."
            ),
            "objective": "Fix `validity_period_hours` so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["tls_self_signed_cert", "validity_period_hours"],
        },
        "broken": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# BUG: validity_period_hours = -1 is invalid; must be a positive number.
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme Corp"
  }

  validity_period_hours = -1

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}
""",
        },
        "solution": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme Corp"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the value must be a positive number.",
            "Certificate validity is measured in hours. `-1` would mean the certificate expired one hour before it was issued — mathematically impossible.",
            "Change `validity_period_hours = -1` to a positive value. `8760` equals 365 days (one year).",
        ],
        "debrief": """\
# Negative Time Makes No Sense

## What Was Broken
`validity_period_hours` must be a positive integer. A value of `-1` would imply the certificate
expires before it is issued, which is logically impossible and rejected by the provider.

## The Fix
```hcl
validity_period_hours = 8760  # 365 days
```

## Common Validity Periods

| Hours  | Duration |
|--------|----------|
| 24     | 1 day (for testing) |
| 720    | 30 days  |
| 8760   | 1 year   |
| 87600  | 10 years (CA certificates) |

## Why It Matters
Many number attributes have minimum value constraints. Negative durations, zero timeouts, and
other impossible values are caught at validate time. Always use meaningful positive values for
time-based attributes.
""",
        "common_mistakes": """\
# Common Mistakes

- **Negative validity periods** — always use a positive number of hours.
- **Very short validity in production** — use at least 8760 hours (1 year) for production certificates.
- **Forgetting `allowed_uses`** — this required attribute specifies what the certificate can be used for.
- **Using self-signed certs in public-facing production services** — they cause browser trust warnings.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — tls-cert-request
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_tls_cert_request():
    return {
        "module": MODULE,
        "slug": "level-14-tls-cert-request",
        "mission": {
            "name": "The Missing Subject",
            "description": (
                "A `tls_cert_request` resource is missing the required `subject {}` block. "
                "Without a subject, the Certificate Signing Request (CSR) cannot be generated."
            ),
            "objective": "Add the `subject {}` block so `terraform apply` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["tls_cert_request", "subject block"],
        },
        "broken": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# BUG: subject {} block is missing. It is required for tls_cert_request.
resource "tls_cert_request" "app_csr" {
  private_key_pem = tls_private_key.app.private_key_pem
}

output "csr_pem" {
  value = tls_cert_request.app_csr.cert_request_pem
}
""",
        },
        "solution": {
            "terraform.tf": TLS_ONLY_TF,
            "main.tf": """\
resource "tls_private_key" "app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "app_csr" {
  private_key_pem = tls_private_key.app.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme"
  }
}

output "csr_pem" {
  value = tls_cert_request.app_csr.cert_request_pem
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error indicates a required block is missing from `tls_cert_request`.",
            "A Certificate Signing Request must contain a subject — the entity requesting the certificate. The `subject {}` block provides this information (the X.509 distinguished name).",
            "Add a `subject` block inside `tls_cert_request` with at least `common_name` and `organization`.",
        ],
        "debrief": """\
# The Missing Subject

## What Was Broken
`tls_cert_request` requires a `subject {}` block. The subject identifies the entity for which the
certificate is being requested (the X.509 Distinguished Name).

## The Fix
```hcl
resource "tls_cert_request" "app_csr" {
  private_key_pem = tls_private_key.app.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme"
  }
}
```

## Subject Block Attributes

| Attribute             | Description |
|----------------------|-------------|
| `common_name`         | Domain name or hostname |
| `organization`        | Legal organization name |
| `organizational_unit` | Department name |
| `locality`            | City |
| `province`            | State or province |
| `country`             | 2-letter ISO country code |
| `postal_code`         | Postal or ZIP code |
| `serial_number`       | Certificate serial number |

## Why It Matters
Nested required blocks (as opposed to optional ones) are a common source of confusion. The resource
schema may require a block even when individual sub-arguments are optional. Always consult the
provider documentation for required nested blocks.
""",
        "common_mistakes": """\
# Common Mistakes

- **Omitting the `subject {}` block entirely** — it is required for `tls_cert_request`.
- **Confusing `tls_cert_request` with `tls_self_signed_cert`** — a CSR is submitted to an external CA; a self-signed cert is both CA and certificate.
- **Not including SANs for production use** — production TLS certificates typically need Subject Alternative Names via `dns_names` or `ip_addresses`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — resource-reference
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_resource_reference():
    return {
        "module": MODULE,
        "slug": "level-15-resource-reference",
        "mission": {
            "name": "Missing the Attribute Dot",
            "description": (
                "A `local_file` resource uses `\"${random_string.token}\"` in its content — "
                "missing the `.result` attribute. This references the whole resource object, "
                "not the string value."
            ),
            "objective": "Fix the reference so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["resource references", "attribute access"],
        },
        "broken": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
}

# BUG: references the whole resource object, not the .result attribute.
resource "local_file" "output" {
  content  = "Token: ${random_string.token}"
  filename = "${path.module}/token.txt"
}
""",
        },
        "solution": {
            "terraform.tf": DEFAULT_TERRAFORM_TF,
            "main.tf": """\
resource "random_string" "token" {
  length  = 16
  special = false
}

resource "local_file" "output" {
  content  = "Token: ${random_string.token.result}"
  filename = "${path.module}/token.txt"
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the value must be a string but you provided an object.",
            "`random_string.token` by itself refers to the entire resource object (all its attributes). In a string interpolation context, Terraform expects a primitive value.",
            "Add `.result` to access the generated string: `${random_string.token.result}`.",
        ],
        "debrief": """\
# Missing the Attribute Dot

## What Was Broken
`${random_string.token}` references the resource object as a whole. In a string interpolation
context, Terraform expects a string, number, or bool — not an object. The correct reference is
`${random_string.token.result}`.

## The Fix
```hcl
content = "Token: ${random_string.token.result}"
```

## Resource Reference Anatomy
```
random_string . token . result
─────────────   ─────   ──────
resource type   name    attribute
```

Every resource reference follows the pattern: `<type>.<name>.<attribute>`

## Why It Matters
Forgetting the attribute name is a very common mistake when writing resource references. Terraform's
type system detects the mismatch between an object and an expected string at validate time, before
any infrastructure is touched.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing `resource_type.name` without an attribute** — always include the specific attribute name.
- **Using `.value` instead of `.result`** — the attribute name depends on the resource type; check the docs.
- **Interpolating objects directly into strings** — Terraform cannot automatically coerce an object to a string.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 16 — implicit-dependency
# ─────────────────────────────────────────────────────────────────────────────
def _level_16_implicit_dependency():
    return {
        "module": MODULE,
        "slug": "level-16-implicit-dependency",
        "mission": {
            "name": "The Wrong Breadcrumb",
            "description": (
                "Two `local_file` resources exist. The second references `local_file.first.path` "
                "to get the first file's path — but `local_file` does not expose a `.path` attribute. "
                "The correct attribute is `.filename`."
            ),
            "objective": "Fix the attribute reference so `terraform apply` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["implicit dependencies", "resource attributes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "first" {
  content  = "primary config"
  filename = "${path.module}/primary.txt"
}

# BUG: local_file does not have a .path attribute. Use .filename instead.
resource "local_file" "second" {
  content  = "secondary config references: ${local_file.first.path}"
  filename = "${path.module}/secondary.txt"
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "first" {
  content  = "primary config"
  filename = "${path.module}/primary.txt"
}

resource "local_file" "second" {
  content  = "secondary config references: ${local_file.first.filename}"
  filename = "${path.module}/secondary.txt"
}
""",
        },
        "validate": validate_tf_apply(),
        "hints": [
            "Run `terraform apply`. The error says `local_file.first` has no attribute called `path`.",
            "Check the `local_file` resource schema. The file path is exposed through a different attribute name.",
            "Replace `.path` with `.filename`. The `local_file` resource stores the file path in the `filename` attribute.",
        ],
        "debrief": """\
# The Wrong Breadcrumb

## What Was Broken
`local_file` does not expose a `.path` attribute. The file path is available through `.filename`,
which mirrors the name of the input argument used to create it.

## The Fix
```hcl
content = "secondary config references: ${local_file.first.filename}"
```

## `local_file` Exported Attributes

| Attribute              | Description |
|-----------------------|-------------|
| `filename`             | The path of the created file |
| `id`                   | SHA1 hash (used as resource ID) |
| `content_md5`          | MD5 hash of the content |
| `content_sha1`         | SHA1 hash of the content |
| `content_sha256`       | SHA256 hash of the content |
| `content_sha512`       | SHA512 hash of the content |
| `content_base64sha256` | SHA256 of the content, base64-encoded |
| `content_base64sha512` | SHA512 of the content, base64-encoded |

## Implicit Dependencies
By referencing `local_file.first.filename`, Terraform automatically creates an implicit ordering
dependency. `local_file.second` will always be created after `local_file.first`.

## Why It Matters
Knowing which attributes a resource exports requires checking the provider documentation. The
`terraform providers schema -json` command can also dump the full resource schema.
""",
        "common_mistakes": """\
# Common Mistakes

- **Guessing attribute names** — always verify against provider docs or `terraform providers schema`.
- **Using `.path` on `local_file`** — the correct attribute is `.filename`.
- **Preferring `depends_on` over implicit attribute references** — implicit dependencies via attribute access are cleaner and self-documenting.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 17 — explicit-depends-on
# ─────────────────────────────────────────────────────────────────────────────
def _level_17_explicit_depends_on():
    return {
        "module": MODULE,
        "slug": "level-17-explicit-depends-on",
        "mission": {
            "name": "Depending on a Ghost",
            "description": (
                "A `local_file` resource has `depends_on = [local_file.nonexistent]`, referencing "
                "a resource that does not exist in the configuration."
            ),
            "objective": "Fix or remove the bogus `depends_on` so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["depends_on", "resource references"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

# BUG: depends_on references a resource that doesn't exist.
resource "local_file" "app" {
  content  = "app data"
  filename = "${path.module}/app.txt"

  depends_on = [local_file.nonexistent]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

resource "local_file" "app" {
  content  = "app data"
  filename = "${path.module}/app.txt"

  depends_on = [local_file.config]
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `local_file.nonexistent` does not exist in the configuration.",
            "`depends_on` must reference resources that actually exist. `local_file.nonexistent` is a phantom reference — there is no such resource block.",
            "Change `[local_file.nonexistent]` to `[local_file.config]` (the resource that does exist) or remove `depends_on` entirely if no explicit ordering is needed.",
        ],
        "debrief": """\
# Depending on a Ghost

## What Was Broken
`depends_on` must reference real resources declared in the configuration. `local_file.nonexistent`
doesn't exist, so Terraform reports an undefined reference error during validate.

## The Fix
```hcl
depends_on = [local_file.config]
```

Or remove `depends_on` entirely if no explicit ordering is required.

## When to Use `depends_on`
Use `depends_on` only when Terraform cannot detect a dependency automatically — for example, when
there is a side-effect dependency with no direct attribute reference:

```hcl
# Terraform cannot infer this: the IAM policy must be attached before the EC2 instance starts
resource "aws_instance" "worker" {
  depends_on = [aws_iam_role_policy_attachment.worker_policy]
}
```

When you use an attribute reference (e.g., `local_file.config.filename`), Terraform infers the
dependency automatically — no `depends_on` needed.

## Why It Matters
Referencing non-existent resources in `depends_on` is a common copy-paste error. Terraform catches
it at validate time, well before any infrastructure changes are made.
""",
        "common_mistakes": """\
# Common Mistakes

- **Referencing non-existent resources in `depends_on`** — Terraform validates all references at parse time.
- **Overusing `depends_on`** — when attribute references exist, implicit dependencies are preferred and clearer.
- **Forgetting that `depends_on` is a list** — the value must be wrapped in `[...]`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 18 — resource-timeout
# ─────────────────────────────────────────────────────────────────────────────
def _level_18_resource_timeout():
    return {
        "module": MODULE,
        "slug": "level-18-resource-timeout",
        "mission": {
            "name": "Duration is a String, Not a Number",
            "description": (
                "A resource has `timeouts { create = 600 }` with a raw number. "
                "Terraform timeout values must be duration strings like `\"10m\"` or `\"1h\"`."
            ),
            "objective": "Fix the `timeouts` block so `terraform validate` passes.",
            "xp": 125,
            "difficulty": "beginner",
            "expected_time": "8m",
            "concepts": ["timeouts block", "duration strings"],
        },
        "broken": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
# BUG: timeout values must be duration strings like "10m", not plain numbers.

resource "null_resource" "slow_task" {
  timeouts {
    create = 600
  }
}
""",
        },
        "solution": {
            "terraform.tf": NULL_ONLY_TF,
            "main.tf": """\
resource "null_resource" "slow_task" {
  timeouts {
    create = "10m"
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says the timeout value must be a string.",
            "Terraform uses Go duration strings for timeouts. A number alone is not valid — you must include a unit suffix.",
            "Change `create = 600` to `create = \"10m\"`. Valid units are `s` (seconds), `m` (minutes), and `h` (hours).",
        ],
        "debrief": """\
# Duration is a String, Not a Number

## What Was Broken
The `timeouts` block expects duration strings like `"10m"` or `"600s"`. Providing a raw number
(`600`) is a type mismatch — the provider schema expects a string.

## The Fix
```hcl
timeouts {
  create = "10m"
}
```

## Duration String Format
Terraform uses Go's `time.Duration` string format:

| String    | Duration         |
|----------|-----------------|
| `"30s"`   | 30 seconds      |
| `"10m"`   | 10 minutes      |
| `"2h"`    | 2 hours         |
| `"1h30m"` | 1 hour 30 minutes |

## Timeout Operation Keys

| Key      | When it applies     |
|---------|---------------------|
| `create` | Resource creation   |
| `update` | Resource updates    |
| `delete` | Resource deletion   |
| `read`   | Data source reads   |

## Why It Matters
Duration strings appear in many places in Terraform (timeouts, `time_sleep` resources, etc.).
Recognizing the pattern and remembering to quote them prevents type errors.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using plain numbers for timeouts** — always include a unit suffix (`s`, `m`, `h`) inside quotes.
- **Forgetting quotes** — duration strings must be quoted; `10m` without quotes is parsed as `10 * m` which is invalid.
- **Not all resources support `timeouts`** — check the provider docs for which operations can be timed out.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 19 — lifecycle-prevent-destroy
# ─────────────────────────────────────────────────────────────────────────────
def _level_19_lifecycle_prevent_destroy():
    return {
        "module": MODULE,
        "slug": "level-19-lifecycle-prevent-destroy",
        "mission": {
            "name": "Protected from Deletion",
            "description": (
                "A resource has `lifecycle { prevent_destroy = true }`. "
                "When you try to plan a destroy, Terraform exits with error code 1 because "
                "the lifecycle rule blocks it."
            ),
            "objective": "Set `prevent_destroy = false` so that `terraform plan -destroy` exits 0 or 2 (not 1).",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["lifecycle", "prevent_destroy"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: prevent_destroy = true blocks any destroy operation.
# Change it to false to allow the resource to be destroyed.

resource "local_file" "important" {
  content  = "critical data"
  filename = "${path.module}/important.txt"

  lifecycle {
    prevent_destroy = true
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "important" {
  content  = "critical data"
  filename = "${path.module}/important.txt"

  lifecycle {
    prevent_destroy = false
  }
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# First apply to create the resource
if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_apply.txt 2>&1; then
    cat /tmp/tf_apply.txt
    echo "FAIL: terraform apply failed"
    exit 1
fi

# Now try plan -destroy; exit 0 or 2 means success (no error), exit 1 means blocked
terraform plan -destroy -detailed-exitcode -no-color -input=false > /tmp/tf_plan.txt 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: terraform plan -destroy succeeded (exit $CODE)"
    exit 0
fi
cat /tmp/tf_plan.txt
echo "FAIL: terraform plan -destroy returned error (exit $CODE) -- prevent_destroy may still be true"
exit 1
"""),
        "hints": [
            "Run `terraform apply` then `terraform plan -destroy`. The destroy plan fails because the resource has `prevent_destroy = true`.",
            "`prevent_destroy = true` is a safety guard for production resources. It blocks *any* Terraform plan that would destroy the resource.",
            "Change `prevent_destroy = true` to `prevent_destroy = false` in the `lifecycle` block.",
        ],
        "debrief": """\
# Protected from Deletion

## What Was Broken
`lifecycle { prevent_destroy = true }` instructs Terraform to abort any plan that would destroy
this resource. This is an intentional safety feature for critical production resources.

## The Fix
```hcl
lifecycle {
  prevent_destroy = false
}
```

## `lifecycle` Meta-Arguments

| Argument                | Description |
|------------------------|-------------|
| `prevent_destroy`       | Block destroy operations when `true` |
| `create_before_destroy` | Create replacement before destroying old resource |
| `ignore_changes`        | Ignore specified attribute changes in future plans |
| `replace_triggered_by`  | Replace this resource when other resources change |

## When to Use `prevent_destroy = true`
- Production databases
- S3 buckets with irreplaceable data
- DNS zones
- Any resource where accidental deletion is catastrophic

## Why It Matters
`prevent_destroy` is a deliberate safeguard. Removing it requires a conscious code change, making
accidental destruction much harder — exactly as designed.
""",
        "common_mistakes": """\
# Common Mistakes

- **Leaving `prevent_destroy = true` in dev/test environments** — makes cleanup operations painful.
- **Thinking `prevent_destroy` protects against manual deletion** — it only blocks Terraform-managed destroys; manual deletion via cloud console still works.
- **Forgetting to remove it before intentionally decommissioning a resource** — the plan will always fail until the protection is lifted.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 20 — lifecycle-ignore-changes
# ─────────────────────────────────────────────────────────────────────────────
def _level_20_lifecycle_ignore_changes():
    return {
        "module": MODULE,
        "slug": "level-20-lifecycle-ignore-changes",
        "mission": {
            "name": "Ignoring What Doesn't Exist",
            "description": (
                "A `local_file` resource has `lifecycle { ignore_changes = [nonexistent_attr] }`, "
                "referencing an attribute that does not exist on `local_file`."
            ),
            "objective": "Fix `ignore_changes` to reference a valid attribute (or use `all`) so `terraform validate` passes.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["lifecycle", "ignore_changes"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# BUG: nonexistent_attr is not an attribute of local_file.
# ignore_changes must reference valid attributes of the resource.

resource "local_file" "app_config" {
  content  = "config_version=1"
  filename = "${path.module}/app.conf"

  lifecycle {
    ignore_changes = [nonexistent_attr]
  }
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "app_config" {
  content  = "config_version=1"
  filename = "${path.module}/app.conf"

  lifecycle {
    ignore_changes = [content]
  }
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The error says `nonexistent_attr` is not a valid attribute of this resource.",
            "`ignore_changes` accepts a list of attribute names that Terraform should stop tracking after initial creation. The names must be valid for the specific resource type.",
            "Replace `nonexistent_attr` with a real attribute like `content`, or use `ignore_changes = all` to ignore all attribute changes.",
        ],
        "debrief": """\
# Ignoring What Doesn't Exist

## What Was Broken
`ignore_changes = [nonexistent_attr]` references an attribute that doesn't exist on `local_file`.
Terraform validates all attribute names listed in `ignore_changes` during `terraform validate`.

## The Fix
```hcl
lifecycle {
  ignore_changes = [content]
}
```

Or to ignore all attribute changes:
```hcl
lifecycle {
  ignore_changes = all
}
```

## `ignore_changes` Use Cases

| Scenario | What to ignore |
|---------|----------------|
| External system modifies tags | `ignore_changes = [tags]` |
| File content managed outside Terraform | `ignore_changes = [content]` |
| Auto-scaling modifies instance count | `ignore_changes = [desired_capacity]` |

## Valid `local_file` Attributes for `ignore_changes`
- `content`
- `content_base64`
- `filename`
- `file_permission`
- `directory_permission`

## `ignore_changes = all`
Using `all` is a blunt instrument — Terraform will never update the resource even when your
configuration changes. Use it sparingly, only when the entire lifecycle is managed externally.

## Why It Matters
Attribute names in `ignore_changes` are validated against the resource schema. A single typo
turns into a validate-time error. Cross-reference with provider documentation when in doubt.
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in attribute names inside `ignore_changes`** — all names are validated against the schema.
- **Using `ignore_changes = all` as a habit** — it creates drift between your config and the actual infrastructure state.
- **Ignoring required attributes** — if you ignore `filename`, tracking the file path becomes unreliable.
- **Confusing `ignore_changes` with `prevent_destroy`** — they serve entirely different purposes.
""",
    }


if __name__ == "__main__":
    build()
