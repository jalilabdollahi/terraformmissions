# Wrong Module Path

## What Was Broken
`source = "../hello"` points to a directory one level *above* the workspace root, which does not exist.
The child module files live at `./modules/hello/` relative to the root.

## Module Source Paths
Local module sources are relative to the file containing the `module` block:

```hcl
module "hello" {
  source = "./modules/hello"   # correct
}
module "hello" {
  source = "../hello"          # goes up — usually wrong from the root
}
```

## After Changing the Path
Run `terraform init` to register the new source, then `terraform plan` to verify.

## Concepts
- `module` block — declares a call to a child module
- `source` — required argument; can be local path, Git URL, or registry address
- Local paths must start with `./` or `../`