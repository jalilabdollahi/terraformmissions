# Module Upgrade Failure — Incident Post-Mortem

## The Incident
The `file_writer` module was upgraded to a new version that renamed the output from
`file_path` to `filename`. The root module was not updated simultaneously, causing a
reference to a non-existent output that broke the plan.

## The Fix
Update the root module reference: `module.file_writer.file_path` → `module.file_writer.filename`.

## Module Upgrade Best Practices

### Pre-Upgrade Checklist
1. Read the module's CHANGELOG or release notes
2. Look for output renames, variable renames, or resource type changes
3. Test the upgrade in a non-prod workspace
4. Update ALL callers of the module before or immediately after upgrading

### Versioned Module References
```hcl
module "file_writer" {
  source  = "git::https://github.com/org/terraform-modules.git//file_writer?ref=v2.0.0"
  # Pin to a specific version — allows controlled upgrades
}
```

### Output Deprecation Pattern
Instead of renaming outputs directly, module authors can deprecate gradually:
```hcl
# Old name kept for backward compatibility
output "file_path" {
  value      = local_file.output.filename
  deprecated = "Use 'filename' instead. Will be removed in v3.0."
}

output "filename" {
  value = local_file.output.filename
}
```

## Key Takeaway
Module output renames are breaking changes. Module authors should deprecate outputs before
removing them. Module consumers should pin versions and audit changes before upgrading.