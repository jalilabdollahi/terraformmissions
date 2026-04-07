# Common Mistakes

- **Using a variable without declaring it** — `var.x` always requires a corresponding `variable "x" {}` block.
- **Declaring variables in subdirectories** — subdirectory `.tf` files are not loaded by the parent module.
- **Duplicate variable declarations** — declaring the same variable twice is an error.