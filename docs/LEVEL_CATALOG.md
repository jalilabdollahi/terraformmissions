# Level Catalog — 15 modules · 272 levels

One row = one lesson. No two rows teach the same thing; implementers must stay inside their row and
must not borrow another row's topic. "Fix" describes the *kind* of break, the story is free.
Levels marked **[cli]** are solved (at least partly) by a terraform CLI action → `solution.sh`;
levels marked **[setup]** need `setup.sh` to create pre-existing state / drift / files.

XP bands: M1 100–150 · M2 100–150 · M3 100–200 · M4 175–300 · M5 150–225 · M6 175–275 · M7 150–275 ·
M8 150–250 · M9 175–250 · M10 225–325 · M11 225–325 · M12 250–400 · M13 225–350 · M14 300–400 · M15 350–600.
Within a module XP and expected_time rise roughly with the level number.

## Module 1 — HCL Foundations (20, beginner)
| # | slug | lesson / break |
|---|---|---|
| 1 | unclosed-block | A resource block is never closed — read the parser error's line numbers |
| 2 | block-keyword-typo | Misspelled top-level block keywords (`outputs`, `varible`) |
| 3 | provider-source-address | `required_providers` source points to a non-existent registry address → init fails |
| 4 | version-constraint-operator | Invalid version constraint operator (`=>`, `~>=`) → init fails |
| 5 | required-version-gate | `required_version` excludes every modern Terraform (`< 1.0`) |
| 6 | unterminated-string | Missing closing quote swallows following lines |
| 7 | heredoc-indentation | `<<EOF` vs `<<-EOF`: generated file has unwanted indentation (exact-content check) |
| 8 | interpolation-syntax | `$(var.x)` / `{var.x}` written instead of `${...}` → literal text ends up in output |
| 9 | literal-dollar-escape | A shell/template snippet needs a literal `${HOME}` → escape with `$${` |
| 10 | number-type-mismatch | Number argument given a non-numeric string |
| 11 | bool-not-string | `"yes"`/`"enabled"` where a bool is required |
| 12 | null-omits-argument | Empty string vs `null` for an optional argument (null = "use default") |
| 13 | comment-syntax | Foreign comment styles (`--`, `;`, `<!-- -->`) — HCL supports `#`, `//`, `/* */` |
| 14 | block-vs-attribute | `lifecycle = { }` / `required_providers = {}` attribute syntax where a block is required |
| 15 | path-module-file | `file()` path relative to the wrong dir — use `${path.module}/templates/...` |
| 16 | undeclared-variable | Config split over files; `var.x` used but never declared — add `variables.tf` |
| 17 | duplicate-resource | Same resource address declared in two files |
| 18 | locals-reference | `local {}` block / `locals.x` reference instead of `locals {}` + `local.x` |
| 19 | identifier-rules | Invalid resource/variable names (leading digit, dots, spaces) |
| 20 | fmt-canonical-style | CI gate: `terraform fmt -check -recursive` must pass (plus behaviour check) |

## Module 2 — Resource Basics (20, beginner)
| # | slug | lesson / break |
|---|---|---|
| 1 | output-directory-path | `local_file` writes to the wrong place; mission requires `out/<name>` under the module |
| 2 | content-vs-base64 | Conflicting `content` + `content_base64`; binary payload needs `content_base64` |
| 3 | file-permission-format | `file_permission` given as number `644` / `"rw-r--r--"` instead of `"0644"` |
| 4 | random-string-charset | `random_string` must match a naming rule (length/lower/no special) — validator regex |
| 5 | random-integer-range | `random_integer` with `min > max` |
| 6 | password-min-constraints | `random_password` minimums exceed `length` |
| 7 | random-uuid-attribute | Referencing a non-existent attribute of `random_uuid` (`.value`) |
| 8 | random-pet-convention | `random_pet` prefix/length/separator must produce `<prefix>-a-b` names |
| 9 | random-id-hex | `random_id` `byte_length` vs `.hex` / `.b64_url` output to get N hex chars |
| 10 | null-triggers-types | `null_resource.triggers` values must be strings — list given; use `join`/`jsonencode` |
| 11 | local-exec-provisioner | Broken `local-exec` (quoting/interpreter/working_dir) that should write a marker file |
| 12 | tls-key-algorithm | `tls_private_key` invalid algorithm/rsa_bits/ecdsa_curve combination |
| 13 | self-signed-cert-uses | `tls_self_signed_cert` missing `allowed_uses` / wrong subject block |
| 14 | cert-request-key-ref | `tls_cert_request` fed the public key instead of `private_key_pem` |
| 15 | reference-not-string | A reference written as a quoted string literal (`"random_pet.x.id"`) ends up verbatim |
| 16 | depends-on-syntax | `depends_on` with quoted strings / attribute paths instead of resource references |
| 17 | time-provider-offset | `time_offset`/`time_static` misuse (string offsets, wrong attribute) |
| 18 | terraform-data-io | Built-in `terraform_data`: `input` vs `output`, `triggers_replace` |
| 19 | prevent-destroy-replace [setup] | Change forces replacement but `prevent_destroy` blocks it — decide & fix |
| 20 | ignore-changes-names [setup] | `ignore_changes` lists attribute names that don't exist on the resource |

## Module 3 — Variables & Outputs (18, beginner→intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | variable-type-default | Declared type and default disagree (`number` with `"three"`) |
| 2 | list-index-bounds | Index past the end of a list variable |
| 3 | map-value-types | `map(string)` default contains nested objects — choose the right type constraint |
| 4 | object-optional-attrs | `object({})` attribute missing from input — use `optional(type, default)` |
| 5 | set-no-index | Indexing a `set(...)` (`[0]`) — sets are unordered |
| 6 | tuple-positions | `tuple([string, number, bool])` default in the wrong order |
| 7 | validation-regex | Validation condition can never be true (bad regex/logic) |
| 8 | validation-can-wrap | Validation errors out instead of failing cleanly — wrap with `can()` |
| 9 | nullable-false | Caller passes `null`; module needs `nullable = false` so the default applies |
| 10 | sensitive-output-flag | Output derived from a sensitive variable must be marked `sensitive` |
| 11 | output-wrong-attribute | Output references an attribute the resource does not export |
| 12 | tfvars-syntax | `.tfvars` written with `:` / JSON-ish syntax |
| 13 | auto-tfvars-loading | Values in `prod.tfvars` never load — only `terraform.tfvars` / `*.auto.tfvars` auto-load |
| 14 | variable-precedence | An `*.auto.tfvars` overrides `terraform.tfvars` unexpectedly — precedence order |
| 15 | tfvars-json | `terraform.tfvars.json` malformed / wrong shape |
| 16 | output-precondition | Output `precondition` guarding a published value |
| 17 | nested-output-path | Output digs into a nested object/map with the wrong key path |
| 18 | default-no-references | Variable default references another variable — move logic into `locals` |

## Module 4 — State Management (20, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | state-show-attribute [setup] | Use `state list`/`state show` to find a value and record it in an answer file |
| 2 | state-mv-rename [setup][cli] | Resource renamed in code → `terraform state mv` keeps the same object (ID unchanged) |
| 3 | state-rm-forget [setup][cli] | Stop managing an object without destroying it — `terraform state rm` |
| 4 | drift-detection [setup] | Managed file edited outside Terraform — detect with plan/refresh-only and reconcile |
| 5 | state-pull-jq [setup][cli] | `terraform state pull` + `jq` to extract serial/lineage facts into an answer file |
| 6 | backup-restore [setup][cli] | State entries lost by a bad command — restore from `terraform.tfstate.backup` |
| 7 | import-cli [setup][cli] | Adopt an existing object with `terraform import` (correct address + ID) |
| 8 | import-block-to | `import {}` block with wrong `to` address / ID |
| 9 | generate-config-out [setup][cli] | `plan -generate-config-out` then clean up the generated config |
| 10 | moved-rename | `moved {}` block for a simple rename (old/new addresses) |
| 11 | removed-forget | `removed {}` + `lifecycle { destroy = false }` to forget without destroying |
| 12 | lock-file-mismatch [cli] | `.terraform.lock.hcl` pins a version that violates the new constraint → `init -upgrade` |
| 13 | local-backend-path [setup] | `backend "local"` path points to the wrong file; existing state elsewhere |
| 14 | backend-migrate [setup][cli] | Changing backend path requires `init -migrate-state` |
| 15 | partial-backend-config [cli] | Backend settings supplied via `-backend-config=<file>`; file missing/wrong |
| 16 | target-apply [cli] | Apply only one component with `-target` (and understand its dependencies) |
| 17 | replace-flag [setup][cli] | Force regeneration of one object with `apply -replace` (ID must change) |
| 18 | untaint [setup][cli] | Object wrongly tainted — `terraform untaint` (ID must NOT change) |
| 19 | replace-provider [setup][cli] | State references a provider address that no longer exists → `state replace-provider` |
| 20 | state-surgery [setup][cli] | Multi-step: rm + import + mv to reconcile a messy state |

## Module 5 — Expressions & Functions (20, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | format-verbs | `format()` verbs (`%d` on string, `%05.1f`, `%q`) |
| 2 | formatlist-lengths | `formatlist()` with list args of different lengths |
| 3 | regex-replace | `replace()` with a regex needs `/.../`; wrong argument order |
| 4 | split-join | `split()`/`join()` separators and empty-element edge cases |
| 5 | argument-expansion | `max(var.list)` needs `...` expansion |
| 6 | lookup-default | `lookup()` default vs direct index on missing key |
| 7 | index-missing-element | `index()` errors when the element is absent — guard with `contains()` |
| 8 | flatten-nested | Nested lists need `flatten()` |
| 9 | merge-vs-concat | `merge()` for maps vs `concat()` for lists, and override order |
| 10 | set-operations | `setunion`/`setintersection`/`setsubtract` semantics |
| 11 | yamldecode-config | `yamldecode(file(...))` with wrong key paths / YAML type surprises |
| 12 | templatefile-vars | `templatefile()` variable map doesn't match template placeholders |
| 13 | cidrsubnet-math | `cidrsubnet()` newbits/netnum overflow — plan an address layout |
| 14 | type-conversion | `tomap`/`tolist`/`tonumber` conversion failures |
| 15 | conditional-types | Ternary branches with incompatible types |
| 16 | for-list-transform | `for` expression over list — wrong iterator names |
| 17 | for-map-grouping | Duplicate keys in a map `for` → grouping mode `...` |
| 18 | for-filter | `for ... if` filter condition wrong |
| 19 | splat-vs-for | Splat `[*]` on a map/object vs `for` expression |
| 20 | template-directives | `%{ if }` / `%{ for }` directives and `~` whitespace stripping |

## Module 6 — Reusable Modules (20, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | module-source-path | Wrong relative `source` path (`./` prefix, directory name) |
| 2 | required-input | Caller omits a required module input |
| 3 | input-type | Caller passes an input of the wrong type |
| 4 | output-name | Caller references a module output name that doesn't exist |
| 5 | expose-output | Child module never declares the output the caller needs |
| 6 | local-version-arg | `version` argument on a local-path module call is invalid |
| 7 | module-count-index | `count` on a module; caller indexes `module.x[0]` / `module.x[*]` |
| 8 | module-for-each-keys | `for_each` module instances addressed by key |
| 9 | module-depends-on | Hidden dependency between modules needs `depends_on` |
| 10 | providers-map-alias | Passing an aliased provider via `providers = { ... }` |
| 11 | path-module-vs-root | `path.module` vs `path.root` inside a child module |
| 12 | sensitive-module-output | Child module output carrying a secret must be `sensitive` |
| 13 | module-input-validation | Child module variable validation catching bad caller input |
| 14 | module-precondition | Resource `precondition` inside a module rejecting invalid combinations |
| 15 | moved-into-module | Resource moved from root into a module — `moved` across module boundary |
| 16 | nested-passthrough | Value threaded through two module levels; a hop is missing |
| 17 | module-required-providers | Child module declares a provider requirement that conflicts with the root |
| 18 | whole-module-output | Using the whole `module.x` object (all outputs) as a value |
| 19 | optional-object-defaults | Module input `object` with `optional()` defaults merged correctly |
| 20 | for-each-outputs-map | Collecting outputs of `for_each` module instances into a map |

## Module 7 — Loops & Conditionals (18, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | count-index-names | `count` resources all get the same name — use `count.index` |
| 2 | count-from-length | `count` should follow `length(var.list)` — hard-coded number |
| 3 | count-off-by-one | Names must be 1-based (`count.index + 1`) |
| 4 | count-conditional-bool | `count = var.enabled ? 1 : 0` with a non-bool variable |
| 5 | count-splat-output | Output of counted resource uses `[0]` instead of `[*]` |
| 6 | for-each-toset | `for_each` given a list — needs `toset()` |
| 7 | each-key-vs-value | `each.key` vs `each.value` mixed up |
| 8 | for-each-output-map | Output map built from a `for_each` resource |
| 9 | for-each-chaining | Resource `for_each = other_resource` (chained instances) |
| 10 | map-of-objects | `for_each` over map of objects; accessing `each.value.attr` |
| 11 | for-each-sensitive | `for_each` cannot use sensitive values — derive non-sensitive keys |
| 12 | dynamic-block-label | `dynamic "x"` label doesn't match the nested block type (archive_file `source`) |
| 13 | dynamic-iterator | Custom `iterator` name vs default block-label iterator |
| 14 | dynamic-optional-block | Emit a nested block only when a value is set (`for_each = x == null ? [] : [x]`) |
| 15 | setproduct-pairs | Nested loops via `setproduct`/`flatten` to build a flat `for_each` map |
| 16 | for-each-unknown-keys | `for_each` keys known only after apply — restructure so keys are static |
| 17 | count-to-for-each-moved | Migrate `count` → `for_each` with `moved` blocks per instance |
| 18 | conditional-module | Module enabled via `count` — outputs become lists (`one()` / `try`) |

## Module 8 — Data Sources (15, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | local-file-data-path | `data "local_file"` reading the wrong path |
| 2 | data-content-base64 | Binary file: `.content` vs `.content_base64` |
| 3 | external-json-contract | `external` program must print a flat JSON object of strings |
| 4 | external-query-input | Passing `query` to the external program (stdin JSON) |
| 5 | external-program-path | Program path / interpreter / exec permissions wrong |
| 6 | data-reads-created-file | Data source reads a file this config creates — needs a dependency |
| 7 | data-count | `count` on a data source and indexing its results |
| 8 | data-for-each | `for_each` on a data source |
| 9 | data-in-module | Module wraps a data source; caller uses the wrong output |
| 10 | remote-state-backend | `terraform_remote_state` with local backend — wrong path |
| 11 | remote-state-outputs | `.outputs.<name>` — the other config's output name/shape |
| 12 | data-filter-for | Filtering data-source results with a `for` expression |
| 13 | data-null-guard | Optional data value is null — guard with `try`/`coalesce` |
| 14 | archive-file-data | `data "archive_file"` source_dir/output_path and hash outputs |
| 15 | sensitive-file-data | `data "local_sensitive_file"` for secrets read from disk |

## Module 9 — Workspaces (12, intermediate)
| # | slug | lesson / break |
|---|---|---|
| 1 | workspace-select [setup][cli] | Resources applied in `default` instead of `staging` — select the right workspace |
| 2 | workspace-name-interpolation | `terraform.workspace` interpolated incorrectly in names |
| 3 | workspace-condition-typo | `terraform.workspace == "prd"` typo breaks prod-only logic |
| 4 | workspace-settings-map | Locals map keyed by workspace is missing a key |
| 5 | default-workspace-guard | Precondition/check refusing to run in `default` |
| 6 | workspace-dir-layout [setup][cli] | Where workspace state lives (`terraform.tfstate.d/`) — fix a misplaced state |
| 7 | workspace-collision | Two workspaces write the same file — include workspace in the path |
| 8 | workspace-for-each | `for_each` driven by per-workspace lists |
| 9 | workspace-module-input | Module input chosen per workspace; new workspace not covered |
| 10 | workspace-delete [setup][cli] | Deleting a workspace that still holds resources — destroy first |
| 11 | workspace-new-from-state [setup][cli] | `workspace new -state=` to seed a workspace from an existing state file |
| 12 | workspace-env-files | Per-environment config files loaded via `file("env/${terraform.workspace}.yaml")` |

## Module 10 — Terraform Testing (18, advanced)
| # | slug | lesson / break |
|---|---|---|
| 1 | test-file-structure | `.tftest.hcl` uses the wrong top-level block |
| 2 | run-command-mode | `run` block command wrong/missing for what it asserts |
| 3 | assert-condition | `assert` condition logic wrong |
| 4 | test-file-variables | File-level `variables {}` block in a test file |
| 5 | expect-failures | `expect_failures` address format for a variable validation |
| 6 | run-variables-override | Per-`run` variable override with the wrong type |
| 7 | run-output-chaining | Later `run` uses `run.<name>.<output>` from an earlier run |
| 8 | plan-vs-apply-values | Asserting on values unknown at plan time in a `command = plan` run |
| 9 | mock-provider | `mock_provider` with `mock_resource` defaults |
| 10 | override-resource | `override_resource` target address wrong |
| 11 | override-data | `override_data` for a data source |
| 12 | test-module-source | `run` with `module { source = ... }` path wrong |
| 13 | sensitive-assertions | Asserting on a sensitive output |
| 14 | test-provider-block | Provider configuration inside a test file conflicts |
| 15 | setup-helper-module | Helper/setup module run pattern in tests |
| 16 | multi-condition-assert | Split a compound `&&` assert into precise asserts with clear messages |
| 17 | for-each-test-index | Asserting on a `for_each` instance by key |
| 18 | precondition-expect | Test that a precondition fails with `expect_failures` on the resource |

## Module 11 — Security & Sensitive Data (18, advanced)
| # | slug | lesson / break |
|---|---|---|
| 1 | secret-via-environment | Secret interpolated into `local-exec` command line — pass via `environment` |
| 2 | sensitivity-propagation | Secret transformed by functions stays sensitive downstream |
| 3 | nonsensitive-misuse | `nonsensitive()` used to unmask a real secret |
| 4 | secret-out-of-tfvars | Secret committed in tfvars — supply via `TF_VAR_` env instead |
| 5 | tf-var-naming | `TF_VAR_` env var name/case doesn't match the variable |
| 6 | generated-not-hardcoded | Hard-coded password → `random_password` |
| 7 | ca-signed-chain | CA key + CA cert + `tls_locally_signed_cert` wiring |
| 8 | cert-early-renewal [setup] | `early_renewal_hours` / validity to rotate an expiring cert |
| 9 | password-keepers | `random_password` `keepers` for controlled rotation |
| 10 | private-key-file-mode | Private key written with `local_file`/0644 → `local_sensitive_file` 0600 |
| 11 | prevent-destroy-secrets [setup] | Protect a secrets store with `prevent_destroy` |
| 12 | ignore-changes-masking [setup] | `ignore_changes` hides security-relevant drift |
| 13 | policy-validation | Variable validation enforcing a security policy (no `0.0.0.0/0`, TLS ≥ 1.2) |
| 14 | precondition-policy | Resource precondition enforcing an invariant |
| 15 | postcondition-audit | Postcondition verifying the created object meets policy |
| 16 | ephemeral-variable | `ephemeral = true` input variables and where they may flow |
| 17 | gitignore-secrets | `.gitignore` must exclude state, `.terraform/`, secret tfvars |
| 18 | ephemeral-output | Ephemeral outputs from a child module (TF ≥ 1.10) |

## Module 12 — Advanced HCL Patterns (20, advanced)
| # | slug | lesson / break |
|---|---|---|
| 1 | provider-alias-reference | `provider = random.x` vs quoted string / undeclared alias |
| 2 | configuration-aliases | Child module needs `configuration_aliases` in required_providers |
| 3 | create-before-destroy [setup] | Replacement order with `create_before_destroy` and a unique-name collision |
| 4 | replace-triggered-by [setup] | `replace_triggered_by` referencing the right resource/attribute |
| 5 | moved-direction [setup] | `moved` block with `from`/`to` swapped |
| 6 | moved-module-rename [setup] | Renaming a module call — `moved { from = module.a  to = module.b }` |
| 7 | moved-resource-type [setup] | `null_resource` → `terraform_data` migration via `moved` |
| 8 | removed-destroy [setup] | `removed {}` with destroy = true to decommission cleanly |
| 9 | import-into-module [setup] | `import` block `to` inside a module path |
| 10 | import-for-each [setup] | `import` blocks with `for_each` (bulk adoption) |
| 11 | import-id-format [setup] | Provider-specific import ID formats |
| 12 | postcondition-self | Postcondition using `self` on a resource |
| 13 | data-precondition | Precondition on a data source |
| 14 | nested-dynamic-iterators | Double-nested `dynamic` blocks — inner/outer iterator naming |
| 15 | provider-functions | Built-in provider functions (`provider::terraform::encode_tfvars` …) |
| 16 | self-in-provisioner | Provisioner refers to its own resource by name → cycle; use `self` |
| 17 | ephemeral-resource | Ephemeral resource value used where only persistent values are allowed |
| 18 | check-block | `check {}` with scoped data + assert vs lifecycle conditions |
| 19 | cross-variable-validation | Validation referencing another variable (TF ≥ 1.9) |
| 20 | complex-refactor [setup] | count→for_each + moved + removed + import in one change, zero destroys |

## Module 13 — Debugging & Troubleshooting (18, advanced)
| # | slug | lesson / break |
|---|---|---|
| 1 | tf-log-trace | `TF_LOG`/`TF_LOG_PATH` to locate a failure; record root cause |
| 2 | provider-schema-lookup | Unsupported argument — use `terraform providers schema -json` to find the right one |
| 3 | console-evaluation | `terraform console` to debug a complex local expression |
| 4 | tainted-after-provisioner [setup] | Failed provisioner left a tainted object — fix and recover |
| 5 | resource-cycle | Two resources reference each other — break the cycle |
| 6 | count-unknown-value | `count` depends on a value known only after apply |
| 7 | perpetual-diff | `timestamp()`/unordered data causes a diff every plan |
| 8 | provider-not-installed [cli] | New provider added without re-running init |
| 9 | conflicting-constraints | Two modules require incompatible provider versions |
| 10 | dueling-resources | Two resources manage the same file — flip-flop diffs |
| 11 | import-already-managed [setup] | Importing an object already in state under another address |
| 12 | provisioner-on-failure | `on_failure = continue` hides a real failure |
| 13 | plan-time-file-error | `file()` of a file created during apply fails at plan time |
| 14 | null-attribute-access | Accessing attributes of a possibly-null value |
| 15 | removed-provider-arguments | Provider major upgrade removed an argument — migrate config |
| 16 | legacy-syntax-upgrade | 0.11-era syntax (`"${var.x}"` lists, `list()`, `map()`) in a modern codebase |
| 17 | graph-analysis [cli] | `terraform graph` to answer a dependency question / fix ordering |
| 18 | crash-log-analysis | Read a crash log to find the offending resource and work around it |

## Module 14 — Performance & Scale (15, expert)
| # | slug | lesson / break |
|---|---|---|
| 1 | parallelism-race | Hidden ordering bug exposed by parallel apply — fix deps, not `-parallelism=1` |
| 2 | target-collateral [setup][cli] | `-target` destroy took dependents with it — recover |
| 3 | refresh-false [setup] | When `-refresh=false` is safe and when it hides drift |
| 4 | refresh-only-apply [setup][cli] | Accept drift into state with `apply -refresh-only` |
| 5 | state-partition | Split a config in two connected via `terraform_remote_state` |
| 6 | module-splitting | Break a monolith module into composable modules |
| 7 | generated-at-scale | 300 copy-pasted blocks → one data-driven `for_each` |
| 8 | saved-plan-apply [cli] | `plan -out` then `apply <planfile>`; stale plan handling |
| 9 | plan-json-policy | `terraform show -json` + jq policy gate script |
| 10 | plugin-cache-config | `TF_PLUGIN_CACHE_DIR` / CLI config for faster inits |
| 11 | expensive-locals | Repeated expensive expressions → computed once in locals |
| 12 | monorepo-layout | Root modules per component sharing a module library |
| 13 | output-contracts | Stable output contracts between team configs |
| 14 | multi-platform-lock [cli] | `terraform providers lock -platform=...` for mixed OS teams |
| 15 | ci-pipeline-script | Write a CI script: fmt-check, init -input=false, validate, plan -out |

## Module 15 — Production War Games (20, expert)
Each incident combines several failures; no incident repeats another's combination.
| # | slug | incident |
|---|---|---|
| 1 | corrupt-state-backup | Truncated state + valid backup + config edited since backup |
| 2 | multi-drift | Five objects drifted in different ways; reconcile each correctly |
| 3 | provider-upgrade-breakage | Lock file + removed arguments + changed defaults after an upgrade |
| 4 | half-applied-pipeline | Apply died midway: some objects exist outside state, some tainted |
| 5 | misplaced-prevent-destroy | Protection on the wrong object blocks a planned decommission |
| 6 | cascade-module-failure | Module A error → B can't plan → C wrong outputs |
| 7 | serial-lineage-conflict | `state push` rejected: lineage/serial mismatch between copies |
| 8 | interrupted-destroy | Partial destroy left orphans and dangling references |
| 9 | module-v2-upgrade | New module version renames resources → would replace 10 objects |
| 10 | renamed-variable-chain | Variable renamed across three module layers |
| 11 | bulk-moved-blocks | 20 addresses changed in a refactor — write all `moved` blocks |
| 12 | wrong-workspace-apply | Prod resources applied into staging workspace — move state between workspaces |
| 13 | bulk-import | Adopt 15 unmanaged objects with `import` blocks + `for_each` |
| 14 | state-split | Split one state into three configs without destroying anything |
| 15 | state-merge | Merge three states into one; ordering & address collisions |
| 16 | external-credential-outage | External program auth failure mid-pipeline — diagnose via logs |
| 17 | team-state-overwrite | Another team overwrote state from an old copy — recover the right one |
| 18 | manual-state-json-edit | Unblock a deployment with a careful hand edit of state JSON |
| 19 | full-recovery-playbook | Corrupt state + drift + tainted + cascade, in one incident |
| 20 | zero-downtime-refactor | Restructure the whole module tree with zero destroy/create |
