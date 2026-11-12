# Common mistakes

- **Renaming the declarations but not the references.** Terraform then reports undeclared variables or resources.
- **Using a hyphen to replace the dot or space and calling it done in expressions.** Hyphens are legal in names, but
  they read as subtraction when mixed with numbers; underscores are safer and the common style.
- **Quoting the name in references (`var."spool_colour"`).** References use bare identifiers.
- **Deleting a resource that has the bad name.** The error vanishes but the label or tag file is not created.
