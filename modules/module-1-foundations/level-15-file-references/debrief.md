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