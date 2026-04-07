# Unreachable Module Source

## What Was Broken
The `source` pointed to a Git URL for a repository that doesn't exist.
`terraform init` tries to clone it and fails.

## Module Source Types
| Source Type | Example |
|------------|---------|
| Local path | `./modules/mymod` |
| Terraform Registry | `hashicorp/consul/aws` |
| GitHub | `github.com/org/repo//modules/mod` |
| Git generic | `git::https://example.com/repo.git` |

## Local Path Sources
For modules within the same repository, use local paths:
```hcl
module "data" {
  source = "./modules/local"
}
```

Local path sources don't require internet access and are fastest for development.

## Concepts
- Local path sources must start with `./` or `../`
- `terraform init` downloads/installs all module sources