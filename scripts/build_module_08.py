#!/usr/bin/env python3
"""Module 8 — Data Sources (15 levels, Intermediate)."""
from __future__ import annotations

from scripts.build_utils import (
    LOCAL_ONLY_TF,
    print_done,
    validate_custom,
    validate_tf_plan,
    validate_tf_validate,
    write_level,
)

MODULE = "module-8-data-sources"

HTTP_TERRAFORM_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}
"""

EXTERNAL_TERRAFORM_TF = """\
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}
"""


def build() -> int:
    levels = [
        _level_01_local_file_datasource(),
        _level_02_local_file_content_access(),
        _level_03_http_datasource(),
        _level_04_http_response_parse(),
        _level_05_external_datasource(),
        _level_06_external_datasource_program(),
        _level_07_datasource_depends_on(),
        _level_08_datasource_count(),
        _level_09_datasource_for_each(),
        _level_10_datasource_in_module(),
        _level_11_datasource_refresh(),
        _level_12_remote_state_datasource(),
        _level_13_remote_state_output(),
        _level_14_datasource_filter(),
        _level_15_datasource_null_check(),
    ]
    for lvl in levels:
        write_level(lvl)
    print_done(MODULE, len(levels))
    return len(levels)


# ─────────────────────────────────────────────────────────────────────────────
# Level 1 — local-file-datasource
# ─────────────────────────────────────────────────────────────────────────────
def _level_01_local_file_datasource():
    return {
        "module": MODULE,
        "slug": "level-1-local-file-datasource",
        "mission": {
            "name": "File Not Found",
            "description": "A data source reads a local file, but the path is wrong and Terraform cannot find it.",
            "objective": "Fix the filename path so the data source can locate `data.txt` and `terraform plan` succeeds.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["data local_file", "filename", "path.module"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "data.txt": "Hello from data source!\n",
            "main.tf": """\
# The data source points to the wrong filename.
# Fix: change "missing.txt" to "data.txt"

data "local_file" "config" {
  filename = "${path.module}/missing.txt"
}

output "config_content" {
  value = data.local_file.config.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "data.txt": "Hello from data source!\n",
            "main.tf": """\
data "local_file" "config" {
  filename = "${path.module}/data.txt"
}

output "config_content" {
  value = data.local_file.config.content
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The error message will show that the file path does not exist. Look at the `filename` attribute.",
            "The file `data.txt` already exists in the same directory as your Terraform config. The `filename` path just needs to reference it correctly.",
            "Change `\"${path.module}/missing.txt\"` to `\"${path.module}/data.txt\"` to point to the existing file.",
        ],
        "debrief": """\
# File Not Found

## What Was Broken
The `data "local_file"` block referenced `missing.txt` which does not exist, while the actual
file `data.txt` was present in the same directory.

## The Fix
```hcl
data "local_file" "config" {
  filename = "${path.module}/data.txt"
}
```

## Key Concepts
- `data` blocks declare **data sources** — they read existing infrastructure or files rather than creating them.
- `path.module` is a built-in reference to the directory of the current module's configuration files.
- Data sources are read during `terraform plan`, so a missing file causes the plan to fail.

## Commands You Used
```bash
terraform plan   # reads data sources and builds execution plan
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Hardcoding absolute paths** — use `${path.module}/` to make paths relative to the config directory.
- **Forgetting data files** — if a `data "local_file"` references a file, that file must exist before `plan` or `apply`.
- **Confusing `resource "local_file"` with `data "local_file"`** — `resource` creates a file; `data` reads an existing one.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 2 — local-file-content-access
# ─────────────────────────────────────────────────────────────────────────────
def _level_02_local_file_content_access():
    return {
        "module": MODULE,
        "slug": "level-2-local-file-content-access",
        "mission": {
            "name": "Lost in Encoding",
            "description": "A data source reads a README file, but the output uses the Base64-encoded attribute instead of plain text.",
            "objective": "Fix the output to use `content` instead of `content_base64` so the output shows readable text.",
            "xp": 150,
            "difficulty": "intermediate",
            "expected_time": "8m",
            "concepts": ["content vs content_base64", "data local_file", "output values"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "readme.txt": "Welcome to TerraformMissions!\n",
            "main.tf": """\
# The output uses the wrong attribute — content_base64 returns Base64, not plain text.
# Fix: change content_base64 to content

data "local_file" "readme" {
  filename = "${path.module}/readme.txt"
}

output "readme_text" {
  value = data.local_file.readme.content_base64
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "readme.txt": "Welcome to TerraformMissions!\n",
            "main.tf": """\
data "local_file" "readme" {
  filename = "${path.module}/readme.txt"
}

output "readme_text" {
  value = data.local_file.readme.content
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw readme_text 2>/dev/null || echo "__MISSING__")

if echo "$ACTUAL" | grep -q "TerraformMissions"; then
    echo "✅ PASS: output 'readme_text' contains readable text"
    exit 0
fi
echo "❌ FAIL: output does not contain expected plain text. Got: $ACTUAL"
exit 1
"""),
        "hints": [
            "Run `terraform apply` and inspect the `readme_text` output. If it looks like a long string of letters and numbers (e.g. `V2VsY29tZ...`), you are reading the Base64 version.",
            "The `data \"local_file\"` resource exposes two content attributes: `content` (plain UTF-8 text) and `content_base64` (Base64-encoded bytes). Use the right one.",
            "Change `data.local_file.readme.content_base64` to `data.local_file.readme.content` in the output block.",
        ],
        "debrief": """\
# Lost in Encoding

## What Was Broken
The output referenced `content_base64`, which returns the file contents encoded as a Base64 string.
The intent was to expose the raw text.

## The Fix
```hcl
output "readme_text" {
  value = data.local_file.readme.content
}
```

## Attributes of `data "local_file"`
| Attribute        | Description |
|-----------------|-------------|
| `content`        | UTF-8 decoded file content (plain text) |
| `content_base64` | Base64-encoded raw bytes (for binary files) |
| `filename`       | Absolute path of the file (computed) |
| `id`             | SHA1 checksum of the file content |

## Why It Matters
When reading binary files (images, archives), use `content_base64`. For text configs, use `content`.
Mixing them up can cause subtle bugs in downstream interpolations.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `content_base64` for text** — always prefer `content` for human-readable files.
- **Using `content` for binary** — binary data may contain bytes that are not valid UTF-8; use `content_base64` instead.
- **Forgetting that `content` includes the trailing newline** — strip it with `trimspace()` if needed.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 3 — http-datasource
# ─────────────────────────────────────────────────────────────────────────────
def _level_03_http_datasource():
    return {
        "module": MODULE,
        "slug": "level-3-http-datasource",
        "mission": {
            "name": "Invalid URL Scheme",
            "description": "An HTTP data source has a malformed URL — it is missing the `https://` scheme.",
            "objective": "Fix the URL so `terraform validate` passes.",
            "xp": 175,
            "difficulty": "intermediate",
            "expected_time": "10m",
            "concepts": ["data http", "URL format", "provider configuration"],
        },
        "broken": {
            "terraform.tf": HTTP_TERRAFORM_TF,
            "main.tf": """\
# The URL is missing the https:// scheme.
# Fix: change "not-a-url" to a valid URL like "https://httpbin.org/get"

data "http" "api" {
  url = "not-a-url"
}

output "response_status" {
  value = data.http.api.status_code
}
""",
        },
        "solution": {
            "terraform.tf": HTTP_TERRAFORM_TF,
            "main.tf": """\
data "http" "api" {
  url = "https://httpbin.org/get"
}

output "response_status" {
  value = data.http.api.status_code
}
""",
        },
        "validate": validate_tf_validate(),
        "hints": [
            "Run `terraform validate`. The `hashicorp/http` provider validates the URL format at plan/validate time and requires a proper absolute URL.",
            "A valid URL must include a scheme (`http://` or `https://`), a hostname, and optionally a path. `not-a-url` has none of those.",
            "Change `url = \"not-a-url\"` to `url = \"https://httpbin.org/get\"`. The `https://` scheme is required.",
        ],
        "debrief": """\
# Invalid URL Scheme

## What Was Broken
The `url` attribute was set to `"not-a-url"`, which has no scheme. The `hashicorp/http` provider
requires a fully-qualified URL beginning with `http://` or `https://`.

## The Fix
```hcl
data "http" "api" {
  url = "https://httpbin.org/get"
}
```

## Key Concepts
- The `hashicorp/http` provider (~> 3.4) exposes `data "http"` for making HTTP GET requests.
- The URL must be absolute and include a scheme.
- Validation happens at `terraform validate` time — no network call is needed to catch this error.

## Useful Attributes
| Attribute          | Description |
|-------------------|-------------|
| `response_body`    | The HTTP response body as a string |
| `status_code`      | The HTTP response status code (integer) |
| `response_headers` | Map of response headers |
""",
        "common_mistakes": """\
# Common Mistakes

- **Missing scheme** — `example.com/api` is not valid; write `https://example.com/api`.
- **HTTP vs HTTPS** — some providers or endpoints only accept `https://`.
- **Not declaring the `http` provider** — the `hashicorp/http` provider must be listed in `required_providers`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 4 — http-response-parse
# ─────────────────────────────────────────────────────────────────────────────
def _level_04_http_response_parse():
    return {
        "module": MODULE,
        "slug": "level-4-http-response-parse",
        "mission": {
            "name": "Wrong JSON Key",
            "description": "A data source reads a JSON file and `jsondecode` is used to extract a value, but the wrong key is referenced.",
            "objective": "Fix the key used in `jsondecode` so the output resolves correctly and `terraform plan` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["jsondecode", "data source parsing", "local_file"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "config.json": '{"app_name": "terraformissions", "version": "2.0", "env": "production"}\n',
            "main.tf": """\
# The jsondecode call accesses "wrong_key" which does not exist in config.json.
# Fix: change "wrong_key" to "app_name" (or another key that exists in the JSON)

data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  parsed = jsondecode(data.local_file.config.content)
}

output "app_name" {
  value = local.parsed["wrong_key"]
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "config.json": '{"app_name": "terraformissions", "version": "2.0", "env": "production"}\n',
            "main.tf": """\
data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  parsed = jsondecode(data.local_file.config.content)
}

output "app_name" {
  value = local.parsed["app_name"]
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform will report that the key `wrong_key` does not exist in the decoded object.",
            "Open `config.json` to see which keys are present: `app_name`, `version`, and `env`.",
            "Change `local.parsed[\"wrong_key\"]` to `local.parsed[\"app_name\"]` (or any valid key from the JSON file).",
        ],
        "debrief": """\
# Wrong JSON Key

## What Was Broken
`jsondecode` successfully parsed the JSON, but the key `"wrong_key"` does not exist in the
decoded map. Terraform catches this during planning.

## The Fix
```hcl
output "app_name" {
  value = local.parsed["app_name"]
}
```

## Key Concepts
- `jsondecode(string)` converts a JSON string into a Terraform value (map, list, etc.).
- Accessing a missing key on a Terraform map causes a plan-time error.
- Use `try(local.parsed["key"], "default")` if the key may be absent.

## Common Pattern
```hcl
locals {
  config = jsondecode(data.local_file.config.content)
}
output "env" {
  value = local.config["env"]
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong key name** — JSON keys are case-sensitive. `App_Name` != `app_name`.
- **Nested key access** — use `local.parsed["outer"]["inner"]` for nested objects.
- **Array indexing** — use `local.parsed["items"][0]` to access the first element of a JSON array.
- **Not using `try()`** — if a key may not exist, wrap access in `try()` to provide a fallback.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 5 — external-datasource
# ─────────────────────────────────────────────────────────────────────────────
def _level_05_external_datasource():
    return {
        "module": MODULE,
        "slug": "level-5-external-datasource",
        "mission": {
            "name": "Script Doesn't Speak JSON",
            "description": "An external data source calls a Python script, but the script prints plain text instead of valid JSON.",
            "objective": "Fix `get_info.py` so it outputs valid JSON, allowing `terraform plan` to succeed.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["external data source", "JSON output", "external program"],
        },
        "broken": {
            "terraform.tf": EXTERNAL_TERRAFORM_TF,
            "get_info.py": """\
#!/usr/bin/env python3
# This script returns plain text — NOT valid JSON.
# The external data source requires valid JSON output.
# Fix: replace the print statement with proper JSON output.

print("version=1.0")
""",
            "main.tf": """\
data "external" "info" {
  program = ["python3", "${path.module}/get_info.py"]
}

output "version" {
  value = data.external.info.result["version"]
}
""",
        },
        "solution": {
            "terraform.tf": EXTERNAL_TERRAFORM_TF,
            "get_info.py": """\
#!/usr/bin/env python3
import json

print(json.dumps({"version": "1.0"}))
""",
            "main.tf": """\
data "external" "info" {
  program = ["python3", "${path.module}/get_info.py"]
}

output "version" {
  value = data.external.info.result["version"]
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. The `external` data source requires the program to write a **single JSON object** to stdout. The current script prints `version=1.0` which is not JSON.",
            "In Python, use the `json` module: `import json; print(json.dumps({\"version\": \"1.0\"}))`. This produces `{\"version\": \"1.0\"}` on stdout.",
            "Replace the `print(\"version=1.0\")` line in `get_info.py` with `import json` and `print(json.dumps({\"version\": \"1.0\"}))`.",
        ],
        "debrief": """\
# Script Doesn't Speak JSON

## What Was Broken
The Python script output plain text (`version=1.0`) instead of a JSON object. The `external`
data source contract requires the program to write a flat JSON object (string-to-string map) to stdout.

## The Fix
```python
#!/usr/bin/env python3
import json
print(json.dumps({"version": "1.0"}))
```

## External Data Source Contract
1. The program reads an optional JSON query from stdin.
2. It writes a flat JSON object (all values must be strings) to stdout.
3. It exits with code 0 on success, non-zero on failure.
4. Any stderr output is shown as a Terraform error.

## Why It Matters
The `data "external"` source is the escape hatch for calling arbitrary programs. Adhering to the
JSON contract is mandatory — even a single extra line of non-JSON output causes a failure.
""",
        "common_mistakes": """\
# Common Mistakes

- **Mixing print statements with JSON output** — any non-JSON line on stdout breaks parsing.
- **Nested objects** — all values in the result map must be strings; nested objects are not allowed.
- **Not flushing stdout** — in some languages, buffer flushing is needed before exit.
- **Exit code** — always exit with code 0 on success; non-zero is treated as an error.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 6 — external-datasource-program
# ─────────────────────────────────────────────────────────────────────────────
def _level_06_external_datasource_program():
    return {
        "module": MODULE,
        "slug": "level-6-external-datasource-program",
        "mission": {
            "name": "Missing Executable",
            "description": "The external data source references a binary that does not exist on the system.",
            "objective": "Fix the `program` list to use a valid executable that outputs JSON, so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["external data source", "executable", "program list"],
        },
        "broken": {
            "terraform.tf": EXTERNAL_TERRAFORM_TF,
            "main.tf": """\
# The program "nonexistent_binary" does not exist.
# Fix: replace with a valid program that outputs JSON.

data "external" "info" {
  program = ["nonexistent_binary"]
}

output "key" {
  value = data.external.info.result["key"]
}
""",
        },
        "solution": {
            "terraform.tf": EXTERNAL_TERRAFORM_TF,
            "main.tf": """\
data "external" "info" {
  program = ["python3", "-c", "import json; print(json.dumps({'key': 'value'}))"]
}

output "key" {
  value = data.external.info.result["key"]
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform reports it cannot find or execute `nonexistent_binary`. The binary must exist and be in your PATH.",
            "You can use any language or tool that outputs valid JSON. Python is always available: `[\"python3\", \"-c\", \"import json; print(json.dumps({'key': 'value'}))\"]`.",
            "Replace `program = [\"nonexistent_binary\"]` with `program = [\"python3\", \"-c\", \"import json; print(json.dumps({'key': 'value'}))\"]`.",
        ],
        "debrief": """\
# Missing Executable

## What Was Broken
The `program` list referenced `nonexistent_binary`, which is not installed on the system.
Terraform tries to execute the program at plan time and fails immediately.

## The Fix
```hcl
data "external" "info" {
  program = ["python3", "-c", "import json; print(json.dumps({'key': 'value'}))"]
}
```

## Key Concepts
- The `program` list is passed directly to the OS exec syscall — no shell expansion occurs.
- The first element is the executable; subsequent elements are arguments.
- Use absolute paths (`/usr/bin/python3`) for reliability in CI/CD environments.
- The program must be present on the machine running `terraform plan` or `apply`.

## Common Alternatives
```hcl
# Shell script
program = ["/bin/bash", "${path.module}/get_data.sh"]

# Node.js
program = ["node", "${path.module}/get_data.js"]

# Python inline
program = ["python3", "-c", "import json,sys; print(json.dumps({'key':'val'}))"]
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Shell built-ins don't work** — `["echo", "{}"]` won't work as expected because `echo` is a shell built-in; use `/bin/echo` or a real script.
- **Relative paths without `path.module`** — Terraform runs from the working directory, which may differ from the module directory.
- **No PATH resolution in plan mode** — if `terraform plan` is run in an environment where the binary is not in PATH, it will fail.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 7 — datasource-depends-on
# ─────────────────────────────────────────────────────────────────────────────
def _level_07_datasource_depends_on():
    return {
        "module": MODULE,
        "slug": "level-7-datasource-depends-on",
        "mission": {
            "name": "Ordering Matters",
            "description": "A data source reads a file that is created by a `local_file` resource, but the data source tries to read the file before it is created.",
            "objective": "Add `depends_on` to the data source so it waits for the resource to create the file first, and `terraform apply` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["data source depends_on", "resource ordering", "apply ordering"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The data source reads a file that is created by local_file.writer,
# but there is no depends_on, so ordering is not guaranteed.
# Fix: add depends_on = [local_file.writer] to the data source.

resource "local_file" "writer" {
  content  = "written by terraform"
  filename = "${path.module}/output.txt"
}

data "local_file" "output" {
  filename = "${path.module}/output.txt"
}

output "file_content" {
  value = data.local_file.output.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "writer" {
  content  = "written by terraform"
  filename = "${path.module}/output.txt"
}

data "local_file" "output" {
  filename   = "${path.module}/output.txt"
  depends_on = [local_file.writer]
}

output "file_content" {
  value = data.local_file.output.content
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# Clean up any previous state
rm -f output.txt terraform.tfstate terraform.tfstate.backup

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw file_content 2>/dev/null || echo "__MISSING__")
if echo "$ACTUAL" | grep -q "written by terraform"; then
    echo "✅ PASS: data source read the file created by the resource"
    exit 0
fi
echo "❌ FAIL: output did not contain expected content. Got: $ACTUAL"
exit 1
"""),
        "hints": [
            "Run `terraform apply`. Because the data source and resource operate in the same apply phase, the data source may try to read the file before `local_file.writer` has created it.",
            "Data sources have a `depends_on` meta-argument, just like resources. It forces Terraform to resolve the dependency before reading the data source.",
            "Add `depends_on = [local_file.writer]` inside the `data \"local_file\" \"output\"` block.",
        ],
        "debrief": """\
# Ordering Matters

## What Was Broken
The data source had no explicit dependency on `local_file.writer`. Terraform does not automatically
infer that a data source should wait for a resource to finish — it only sees the file path string,
not the relationship.

## The Fix
```hcl
data "local_file" "output" {
  filename   = "${path.module}/output.txt"
  depends_on = [local_file.writer]
}
```

## When to Use `depends_on` on Data Sources
Normally, if a data source references a resource attribute (e.g., `resource.name.id`), Terraform
infers the dependency automatically. But when the relationship is **implicit** (like a shared file
path), you must declare it explicitly with `depends_on`.

## Key Takeaway
Data sources run during the **planning** phase by default. If a data source depends on a resource
that doesn't exist yet, use `depends_on` to push the data source read into the **apply** phase.
""",
        "common_mistakes": """\
# Common Mistakes

- **Assuming Terraform infers file-path dependencies** — it doesn't; only attribute references are tracked.
- **Using `depends_on` everywhere** — overuse can create hidden coupling; only use it when truly needed.
- **Forgetting that `depends_on` defers the data source read** — the data source will be re-read during apply, not plan.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 8 — datasource-count
# ─────────────────────────────────────────────────────────────────────────────
def _level_08_datasource_count():
    return {
        "module": MODULE,
        "slug": "level-8-datasource-count",
        "mission": {
            "name": "Index Out of Range",
            "description": "A data source uses `count = 3` to read three config files, but the output references index `[3]` which is out of range.",
            "objective": "Fix the out-of-range index so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["data source count", "indexing", "count.index"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "config-0.txt": "config for instance 0\n",
            "config-1.txt": "config for instance 1\n",
            "config-2.txt": "config for instance 2\n",
            "main.tf": """\
# count = 3 creates indices 0, 1, 2.
# The output references index [3] which does not exist.
# Fix: change [3] to a valid index like [0], [1], or [2].

data "local_file" "configs" {
  count    = 3
  filename = "${path.module}/config-${count.index}.txt"
}

output "first_config" {
  value = data.local_file.configs[3].content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "config-0.txt": "config for instance 0\n",
            "config-1.txt": "config for instance 1\n",
            "config-2.txt": "config for instance 2\n",
            "main.tf": """\
data "local_file" "configs" {
  count    = 3
  filename = "${path.module}/config-${count.index}.txt"
}

output "first_config" {
  value = data.local_file.configs[0].content
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. With `count = 3`, Terraform creates instances at indices 0, 1, and 2. Index 3 is out of bounds.",
            "In programming and Terraform, count-based resources are zero-indexed. `count = 3` gives you indices 0, 1, and 2.",
            "Change `data.local_file.configs[3].content` to `data.local_file.configs[0].content` to access the first instance.",
        ],
        "debrief": """\
# Index Out of Range

## What Was Broken
`count = 3` creates instances with indices `0`, `1`, and `2`. Accessing index `3` is out of bounds
and causes a plan-time error.

## The Fix
```hcl
output "first_config" {
  value = data.local_file.configs[0].content
}
```

## Count Indexing Rules
- `count = N` creates instances indexed `0` through `N-1`.
- Access them with `resource_type.name[index]`.
- Within the resource, use `count.index` to get the current instance's index.

## Accessing All Instances
```hcl
output "all_configs" {
  value = [for f in data.local_file.configs : f.content]
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Off-by-one** — `count = 3` means valid indices are 0, 1, 2. Index 3 does not exist.
- **Using count where for_each fits better** — if you have a set of named items, `for_each` is more readable.
- **Splat operator misuse** — `data.local_file.configs[*].content` returns a list of all contents.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 9 — datasource-for-each
# ─────────────────────────────────────────────────────────────────────────────
def _level_09_datasource_for_each():
    return {
        "module": MODULE,
        "slug": "level-9-datasource-for-each",
        "mission": {
            "name": "Missing Map Key",
            "description": "A data source uses `for_each` over a set of filenames, but the output references the data source without a key.",
            "objective": "Fix the output to use the correct `for_each` key syntax so `terraform plan` succeeds.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["data source for_each", "for_each keys", "map access"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "a.txt": "Content of file A\n",
            "b.txt": "Content of file B\n",
            "main.tf": """\
# for_each creates instances keyed by the set values ("a.txt", "b.txt").
# The output is missing the key — you must reference data.local_file.files["a.txt"].content.
# Fix: add the key ["a.txt"] to the reference.

data "local_file" "files" {
  for_each = toset(["a.txt", "b.txt"])
  filename = "${path.module}/${each.key}"
}

output "file_a_content" {
  value = data.local_file.files.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "a.txt": "Content of file A\n",
            "b.txt": "Content of file B\n",
            "main.tf": """\
data "local_file" "files" {
  for_each = toset(["a.txt", "b.txt"])
  filename = "${path.module}/${each.key}"
}

output "file_a_content" {
  value = data.local_file.files["a.txt"].content
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. When `for_each` is used, Terraform creates a map of instances keyed by the set values. You cannot access the entire map as a single instance.",
            "To access a specific `for_each` instance, use the key: `data.local_file.files[\"a.txt\"]`. The key must be one of the values from the `for_each` set.",
            "Change `data.local_file.files.content` to `data.local_file.files[\"a.txt\"].content`.",
        ],
        "debrief": """\
# Missing Map Key

## What Was Broken
When a data source uses `for_each`, it becomes a **map** of instances. You cannot access it
directly as `data.local_file.files` — you must specify which key you want.

## The Fix
```hcl
output "file_a_content" {
  value = data.local_file.files["a.txt"].content
}
```

## for_each vs count
| Feature    | `count`             | `for_each`                   |
|-----------|---------------------|------------------------------|
| Index type | integer (0, 1, 2)  | string key from map/set      |
| Access     | `resource[0]`       | `resource["key"]`            |
| Stability  | moves on removal    | stable — keyed by value      |

## Iterating All Instances
```hcl
output "all_contents" {
  value = { for k, v in data.local_file.files : k => v.content }
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Forgetting the key** — `data.local_file.files.content` fails; always include the key.
- **Wrong key type** — the key must match exactly what is in the `for_each` set or map.
- **Using `[*]` splat with `for_each`** — the splat operator only works with `count`-based resources.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 10 — datasource-in-module
# ─────────────────────────────────────────────────────────────────────────────
def _level_10_datasource_in_module():
    return {
        "module": MODULE,
        "slug": "level-10-datasource-in-module",
        "mission": {
            "name": "Module Output Name Mismatch",
            "description": "A child module reads a data source and exposes the result as an output. The root module references the wrong output name.",
            "objective": "Fix the root module's output reference to use the correct output name and `terraform plan` passes.",
            "xp": 200,
            "difficulty": "intermediate",
            "expected_time": "12m",
            "concepts": ["data sources in modules", "module outputs", "output reference"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "info.txt": "module data source content\n",
            "modules/reader/terraform.tf": LOCAL_ONLY_TF,
            "modules/reader/main.tf": """\
variable "filepath" {
  type = string
}

data "local_file" "file" {
  filename = var.filepath
}

output "file_content" {
  value = data.local_file.file.content
}
""",
            "main.tf": """\
# The child module exposes output "file_content",
# but the root module references "content" (wrong name).
# Fix: change module.reader.content to module.reader.file_content

module "reader" {
  source   = "./modules/reader"
  filepath = "${path.module}/info.txt"
}

output "result" {
  value = module.reader.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "info.txt": "module data source content\n",
            "modules/reader/terraform.tf": LOCAL_ONLY_TF,
            "modules/reader/main.tf": """\
variable "filepath" {
  type = string
}

data "local_file" "file" {
  filename = var.filepath
}

output "file_content" {
  value = data.local_file.file.content
}
""",
            "main.tf": """\
module "reader" {
  source   = "./modules/reader"
  filepath = "${path.module}/info.txt"
}

output "result" {
  value = module.reader.file_content
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform reports that the module does not have an output named `content`. Check the child module's outputs.",
            "Open `modules/reader/main.tf` and look at the `output` block. The output is named `file_content`, not `content`.",
            "Change `module.reader.content` to `module.reader.file_content` in the root `main.tf`.",
        ],
        "debrief": """\
# Module Output Name Mismatch

## What Was Broken
The root module referenced `module.reader.content`, but the child module defines its output
as `file_content`. Output names must match exactly.

## The Fix
```hcl
output "result" {
  value = module.reader.file_content
}
```

## Module Output Access Pattern
```
module.<module_name>.<output_name>
```

## Key Concepts
- Child module outputs are the **only** way to expose values to the parent.
- The output name in the child must exactly match what the parent references.
- Use `terraform plan` to get a clear error when names don't match.
""",
        "common_mistakes": """\
# Common Mistakes

- **Case sensitivity** — `File_Content` != `file_content`.
- **Accessing internal resources directly** — you cannot do `module.reader.data.local_file.file.content`; you must use an output.
- **Forgetting to re-run `terraform init`** — after changing module source paths, always re-initialize.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 11 — datasource-refresh
# ─────────────────────────────────────────────────────────────────────────────
def _level_11_datasource_refresh():
    return {
        "module": MODULE,
        "slug": "level-11-datasource-refresh",
        "mission": {
            "name": "Stale Data Source",
            "description": "A `local_file` resource and a data source both reference the same file. The data source uses the wrong attribute after the file content changes.",
            "objective": "Fix the data source attribute reference and run `terraform plan -refresh-only` to verify the data source reflects current state.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["-refresh-only", "data source refresh", "content attribute"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The data source attribute used is wrong — content_base64 instead of content.
# Fix: change data.local_file.reader.content_base64 to data.local_file.reader.content

resource "local_file" "writer" {
  content  = "v1 content"
  filename = "${path.module}/shared.txt"
}

data "local_file" "reader" {
  filename   = "${path.module}/shared.txt"
  depends_on = [local_file.writer]
}

output "file_text" {
  value = data.local_file.reader.content_base64
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
resource "local_file" "writer" {
  content  = "v1 content"
  filename = "${path.module}/shared.txt"
}

data "local_file" "reader" {
  filename   = "${path.module}/shared.txt"
  depends_on = [local_file.writer]
}

output "file_text" {
  value = data.local_file.reader.content
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

# First apply to set up the resource
if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

# Now check that plan -refresh-only exits cleanly
terraform plan -refresh-only -no-color -input=false > /tmp/tf_refresh.txt 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    # Verify output is readable text (not base64)
    ACTUAL=$(terraform output -raw file_text 2>/dev/null || echo "__MISSING__")
    if echo "$ACTUAL" | grep -q "v1 content"; then
        echo "✅ PASS: data source returns readable text content"
        exit 0
    fi
    echo "❌ FAIL: output does not contain expected text. Got: $ACTUAL"
    exit 1
fi
echo "❌ FAIL: terraform plan -refresh-only failed"
cat /tmp/tf_refresh.txt
exit 1
"""),
        "hints": [
            "Run `terraform apply` and then inspect the `file_text` output. If it's a Base64 blob, you are using the wrong attribute.",
            "The `data \"local_file\"` resource has two content attributes: `content` (plain text) and `content_base64` (Base64). Use `content` for human-readable files.",
            "Change `data.local_file.reader.content_base64` to `data.local_file.reader.content` in the output block.",
        ],
        "debrief": """\
# Stale Data Source

## What Was Broken
The output referenced `content_base64` instead of `content`. After apply, the output showed
Base64-encoded text instead of the human-readable file content.

## The Fix
```hcl
output "file_text" {
  value = data.local_file.reader.content
}
```

## terraform plan -refresh-only
The `-refresh-only` flag tells Terraform to update its state to reflect the real current state
of infrastructure **without** making any changes. This is useful for detecting drift between
the state file and the actual system.

```bash
terraform plan -refresh-only     # what has changed outside of Terraform?
terraform apply -refresh-only    # accept the drift into the state file
```

## Key Takeaway
Use `content` for UTF-8 text files. Use `content_base64` for binary files or when you need
to pass the content to another resource that expects Base64 encoding.
""",
        "common_mistakes": """\
# Common Mistakes

- **Using `-refresh-only` to fix drift** — it updates the state to match reality, but does not fix the actual resource.
- **Forgetting `depends_on`** — a data source reading a resource-created file needs explicit ordering.
- **Base64 confusion** — `content_base64` looks like a long random string; if your output looks garbled, switch to `content`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 12 — remote-state-datasource
# ─────────────────────────────────────────────────────────────────────────────
def _level_12_remote_state_datasource():
    return {
        "module": MODULE,
        "slug": "level-12-remote-state-datasource",
        "mission": {
            "name": "Remote State Path Wrong",
            "description": "A `terraform_remote_state` data source points to a local state file, but the path is incorrect.",
            "objective": "Fix the `config.path` so it points to the state file created by the validate script and `terraform plan` succeeds.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["terraform_remote_state", "backend local", "state file path"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The remote state config.path is wrong — it points to a non-existent path.
# Fix: change the path to "./network.tfstate"

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./wrong-path/network.tfstate"
  }
}

output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./network.tfstate"
  }
}

output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create a fake local state file that the data source will read
cat > "${SCRIPT_DIR}/network.tfstate" <<'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "fake-lineage-for-test",
  "outputs": {
    "vpc_id": {
      "value": "vpc-12345678",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}
STATEOF

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded with remote state"
    rm -f "${SCRIPT_DIR}/network.tfstate"
    exit 0
fi

cat /tmp/tf_out.txt
rm -f "${SCRIPT_DIR}/network.tfstate"
echo "❌ FAIL: terraform plan failed"
exit 1
"""),
        "hints": [
            "Run `terraform plan`. The error says the state file path does not exist. The validate script creates a file called `network.tfstate` in the current directory.",
            "`data \"terraform_remote_state\"` with `backend = \"local\"` reads a `.tfstate` file on disk. The `config.path` must point to that exact file.",
            "Change `path = \"./wrong-path/network.tfstate\"` to `path = \"./network.tfstate\"`.",
        ],
        "debrief": """\
# Remote State Path Wrong

## What Was Broken
The `config.path` pointed to `./wrong-path/network.tfstate` which does not exist. The
`terraform_remote_state` data source requires the state file to be accessible.

## The Fix
```hcl
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./network.tfstate"
  }
}
```

## terraform_remote_state
This data source reads outputs from another Terraform state file, enabling state sharing
between configurations without re-creating resources.

```hcl
# Access outputs from the remote state
output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
```

## Backends Supported
- `local` — reads a `.tfstate` file on disk
- `s3` — reads from an S3 bucket
- `gcs`, `azurerm`, `remote`, etc.

## Best Practice
For production, prefer `terraform_remote_state` with a remote backend (S3, GCS) over local
state files for team collaboration.
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrong path** — relative paths are resolved from the Terraform working directory, not the config file.
- **State file not initialized** — the source state file must exist before the consumer can plan.
- **Circular dependencies** — avoid having two stacks read each other's remote state.
- **Output not exposed** — the source stack must have `output` blocks for values you want to consume.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 13 — remote-state-output
# ─────────────────────────────────────────────────────────────────────────────
def _level_13_remote_state_output():
    return {
        "module": MODULE,
        "slug": "level-13-remote-state-output",
        "mission": {
            "name": "Wrong Output Key",
            "description": "A `terraform_remote_state` data source is configured correctly, but the output references a key that does not exist in the remote state.",
            "objective": "Fix the output key to `vpc_id` so `terraform plan` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["remote state output access", "terraform_remote_state", "outputs map"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# The remote state has output "vpc_id" but we reference "wrong_output".
# Fix: change outputs.wrong_output to outputs.vpc_id

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "./vpc.tfstate"
  }
}

output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.wrong_output
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "./vpc.tfstate"
  }
}

output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}
""",
        },
        "validate": validate_custom("""\
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create fake remote state with vpc_id output
cat > "${SCRIPT_DIR}/vpc.tfstate" <<'STATEOF'
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 1,
  "lineage": "fake-lineage-vpc",
  "outputs": {
    "vpc_id": {
      "value": "vpc-abcdef01",
      "type": "string"
    }
  },
  "resources": [],
  "check_results": null
}
STATEOF

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded accessing correct output key"
    rm -f "${SCRIPT_DIR}/vpc.tfstate"
    exit 0
fi

cat /tmp/tf_out.txt
rm -f "${SCRIPT_DIR}/vpc.tfstate"
echo "❌ FAIL: terraform plan failed"
exit 1
"""),
        "hints": [
            "Run `terraform plan` after the validate script creates the state file. The error will indicate `wrong_output` does not exist in the remote state outputs.",
            "The remote state file exposes an output named `vpc_id`. Check the state file structure — outputs are listed under the `outputs` key.",
            "Change `data.terraform_remote_state.vpc.outputs.wrong_output` to `data.terraform_remote_state.vpc.outputs.vpc_id`.",
        ],
        "debrief": """\
# Wrong Output Key

## What Was Broken
The reference used `outputs.wrong_output`, but the remote state only contains `outputs.vpc_id`.
Accessing a non-existent key causes a plan-time error.

## The Fix
```hcl
output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

## Accessing Remote State Outputs
```hcl
# Single output
data.terraform_remote_state.vpc.outputs.vpc_id

# All outputs as a map
data.terraform_remote_state.vpc.outputs

# Safe access with fallback
try(data.terraform_remote_state.vpc.outputs.optional_key, "default")
```

## Inspecting a State File
To see available outputs, inspect the state file or the source stack:
```bash
# In the source stack directory
terraform output -json
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Typos in output names** — output names are case-sensitive.
- **Output not declared in source** — the source stack must have an `output` block; resources are not automatically accessible.
- **Stale state** — if the source stack was updated, you need to re-plan the consumer to pick up new outputs.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 14 — datasource-filter
# ─────────────────────────────────────────────────────────────────────────────
def _level_14_datasource_filter():
    return {
        "module": MODULE,
        "slug": "level-14-datasource-filter",
        "mission": {
            "name": "String Is Not a List",
            "description": "A `for` expression tries to filter data source content directly, but the content is a string. It must be decoded with `jsondecode` first.",
            "objective": "Wrap the data source content in `jsondecode()` before filtering so `terraform plan` succeeds.",
            "xp": 225,
            "difficulty": "intermediate",
            "expected_time": "15m",
            "concepts": ["data source content", "jsondecode", "for expression", "filtering"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "services.json": '[{"name":"api","enabled":true},{"name":"worker","enabled":false},{"name":"scheduler","enabled":true}]\n',
            "main.tf": """\
# data.local_file.services.content is a STRING, not a list.
# The for expression cannot iterate over a string directly.
# Fix: wrap the content in jsondecode() before the for expression.

data "local_file" "services" {
  filename = "${path.module}/services.json"
}

locals {
  enabled_services = [for s in data.local_file.services.content : s if s.enabled]
}

output "enabled" {
  value = local.enabled_services
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "services.json": '[{"name":"api","enabled":true},{"name":"worker","enabled":false},{"name":"scheduler","enabled":true}]\n',
            "main.tf": """\
data "local_file" "services" {
  filename = "${path.module}/services.json"
}

locals {
  enabled_services = [for s in jsondecode(data.local_file.services.content) : s if s.enabled]
}

output "enabled" {
  value = local.enabled_services
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Terraform complains that it cannot iterate over a string with a `for` expression. `data.local_file.services.content` is a raw string.",
            "To iterate over the JSON array in the file, you must first convert the string to a Terraform list using `jsondecode()`.",
            "Change `for s in data.local_file.services.content` to `for s in jsondecode(data.local_file.services.content)` in the `locals` block.",
        ],
        "debrief": """\
# String Is Not a List

## What Was Broken
`data.local_file.services.content` returns a raw string. A `for` expression cannot iterate
over a string as if it were a list. `jsondecode()` must be called first to convert the JSON
string to a native Terraform list.

## The Fix
```hcl
locals {
  enabled_services = [
    for s in jsondecode(data.local_file.services.content) : s if s.enabled
  ]
}
```

## Pattern: Read JSON - Decode - Filter
```hcl
data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  items   = jsondecode(data.local_file.config.content)
  active  = [for item in local.items : item if item.active]
}
```

## Why This Matters
JSON files are commonly used as configuration sources in Terraform. Remember that
`local_file.content` always returns a string — parsing is your responsibility.
""",
        "common_mistakes": """\
# Common Mistakes

- **Iterating over a string** — strings in Terraform iterate character by character in `for` expressions; decode JSON first.
- **Assuming `content` auto-parses** — Terraform never auto-parses file content; always call `jsondecode()` or `yamldecode()` explicitly.
- **Filter syntax** — the `if` clause in a `for` expression uses the element itself: `for x in list : x if x.condition`.
""",
    }


# ─────────────────────────────────────────────────────────────────────────────
# Level 15 — datasource-null-check
# ─────────────────────────────────────────────────────────────────────────────
def _level_15_datasource_null_check():
    return {
        "module": MODULE,
        "slug": "level-15-datasource-null-check",
        "mission": {
            "name": "Missing File, Missing Guard",
            "description": "A data source may not find the target file, and the output has no null/error guard. Fix it to handle the missing case gracefully.",
            "objective": "Wrap the data source access in `try()` to provide a default value when the file is missing, so `terraform plan` succeeds.",
            "xp": 250,
            "difficulty": "advanced",
            "expected_time": "18m",
            "concepts": ["try()", "null guards", "data source errors", "graceful fallback"],
        },
        "broken": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
# If "maybe.txt" does not exist, the plan fails with a hard error.
# Fix: wrap the output value in try() to provide a default.

data "local_file" "maybe" {
  filename = "${path.module}/maybe.txt"
}

output "file_content" {
  value = data.local_file.maybe.content
}
""",
        },
        "solution": {
            "terraform.tf": LOCAL_ONLY_TF,
            "main.tf": """\
data "local_file" "maybe" {
  filename = "${path.module}/maybe.txt"
}

output "file_content" {
  value = try(data.local_file.maybe.content, "default")
}
""",
        },
        "validate": validate_tf_plan(),
        "hints": [
            "Run `terraform plan`. Because `maybe.txt` does not exist in the directory, the data source cannot read it and the plan fails. You need to handle this case.",
            "Terraform's `try()` function evaluates expressions in order and returns the first one that succeeds without error. If the first expression errors, it falls back to the next.",
            "Change `value = data.local_file.maybe.content` to `value = try(data.local_file.maybe.content, \"default\")`. This returns `\"default\"` if the data source cannot read the file.",
        ],
        "debrief": """\
# Missing File, Missing Guard

## What Was Broken
The data source referenced a file that does not exist. Without a guard, Terraform raises an
error during the plan phase and halts execution.

## The Fix
```hcl
output "file_content" {
  value = try(data.local_file.maybe.content, "default")
}
```

## try() Function
`try(expr1, expr2, ...)` evaluates each expression left to right and returns the first one
that does not produce an error. It is the idiomatic Terraform way to handle optional values.

```hcl
# Single fallback
try(some_resource.name.attribute, "fallback")

# Multiple fallbacks
try(map["key"], local.default_map["key"], "hardcoded-default")
```

## Caution
`try()` silently swallows errors. Use it carefully — only wrap the specific expression
that might fail, not an entire block. Overuse of `try()` can hide real configuration errors.

## Alternative: `can()`
`can(expr)` returns `true` if the expression succeeds, `false` otherwise. Useful in
`condition` checks:
```hcl
locals {
  file_exists = can(data.local_file.maybe.content)
}
```
""",
        "common_mistakes": """\
# Common Mistakes

- **Wrapping too much in `try()`** — only guard the specific attribute that might be missing.
- **Ignoring the error** — if a data source consistently fails, investigate the root cause rather than always falling back.
- **Using `try()` on required values** — do not use `try()` to mask errors on configuration that should always be present.
- **Confusing `try()` with `can()`** — `try()` returns a value; `can()` returns a boolean.
""",
    }


if __name__ == "__main__":
    build()
