# Debrief — tfvars is HCL, not YAML

A `.tfvars` file looks like a config format of its own, but it is plain HCL with one restriction: only
attribute assignments. No blocks, no expressions that reference other things, no `variable` keyword.
The right-hand side can be any literal: strings, numbers, bools, lists `[...]`, maps/objects `{ k = v }`.

Because people copy snippets from wikis, YAML, JSON and `.env` files, the typical failures are:
- `key: value` (YAML) or `"key": "value"` (JSON) — wrong separator.
- `key = value,` with trailing commas outside of collection literals.
- `export KEY=value` (shell style).
- A top-level `{ ... }` wrapper, which is JSON.

If you really want JSON, Terraform supports it with the **file name** `terraform.tfvars.json` (or
`*.auto.tfvars.json`); the extension decides the parser. The same content in a `.tfvars` file must be HCL.

Note that this level's variables have no defaults: a missing or broken tfvars file would otherwise be
silently masked by defaults, and in automation (`TF_INPUT=0`) Terraform fails with "No value for
required variable".

## Real-world takeaway

Run `terraform validate` plus `terraform plan` in CI so a malformed tfvars file is caught in review. Use
`terraform fmt` on tfvars too; it normalises alignment and will flag the worst syntax errors.
