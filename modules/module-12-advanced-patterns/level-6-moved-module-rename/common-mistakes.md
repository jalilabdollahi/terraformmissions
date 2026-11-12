# Common mistakes

- **Writing a moved block for each resource inside the module.** It works, but misses the point: new resources
  added later to the module would not follow, and it is four times the code.
- **Using `from = "module.shaft_a"` with quotes.** Addresses in moved blocks are references, not strings.
- **Renaming the call back to shaft_a.** That undoes the refactor that the south shaft already follows.
- **Pointing `to` at `module.south_shaft`.** Both objects would land in an occupied address and Terraform
  refuses; even if it did not, the north data would be overwritten.
