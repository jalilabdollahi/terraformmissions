# Wrong Output Name

## What Was Broken
`module.mymod.wrong_output` references an output called `wrong_output` that the child module does not declare.
The child only exposes `file_path`.

## Module Output Reference Syntax
```
module.<module_label>.<output_name>
```

To know which outputs are available, check the child module's `outputs.tf`:
```hcl
output "file_path" {
  value = local_file.msg.filename
}
```

Then reference it from the root:
```hcl
output "result" {
  value = module.mymod.file_path
}
```

## Concepts
- Only declared `output` blocks are accessible from a parent module.
- Referencing a non-existent output is a validation error, not a runtime error.