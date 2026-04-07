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