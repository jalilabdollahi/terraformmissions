# Common mistakes

- **Changing the version to `"1.2.0"` or `">= 0"`.** Any `version` argument is rejected for a local path.
- **Pointing `source` at a registry-looking address** (`hinoki/folds/local`) to keep the version line. That module does
  not exist, the network is off, and the repository's own folder stops being used.
- **Putting the pin in `terraform.tf`.** `required_providers` pins providers, not modules.
- **Commenting out the module** and writing the sheet from the root. The mission needs `module.pattern` to produce it.
