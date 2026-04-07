# Wrong Module Source Path in Test

## What Was Broken
The `module "greeter"` block used `source = "../wrong/path"`, which does not contain a valid
Terraform module. The correct path is `"./modules/greeter"` relative to the root config.

## Local Module Path Rules
- Paths starting with `./` or `../` are treated as local filesystem paths.
- The path is relative to the calling configuration file (not the working directory).
- After changing a `source` path, run `terraform init` to update the module cache.

## Module Source Types
| Format                    | Type |
|---------------------------|------|
| `"./modules/foo"`         | Local path |
| `"hashicorp/consul/aws"`  | Terraform Registry |
| `"git::https://..."`      | Git URL |
| `"github.com/..."`        | GitHub shorthand |

## Why It Matters
Incorrect module source paths are a frequent cause of init failures. Understanding relative vs.
absolute paths and the module cache is essential for working with modular Terraform codebases.