# path.root vs path.module

## Path Variables in Terraform
| Variable      | Value |
|--------------|-------|
| `path.module` | Directory of the **current** module's `.tf` files |
| `path.root`   | Directory of the **root** module |
| `path.cwd`    | Current working directory when Terraform was invoked |

## Why It Matters in Child Modules
Inside a child module, `path.root` still points to the *root* module.
If the child writes files using `${path.root}/...`, those files land in the
root's directory, not next to the child module's files.

## Best Practice
In child modules, use `path.module` for file paths relative to the module's own directory:
```hcl
filename = "${path.module}/output.txt"   # child's directory
filename = "${path.root}/output.txt"     # root's directory (probably wrong in a child)
```