# Debrief — import blocks are reviewable adoption

An `import` block pairs a destination address (`to`) with the real object's ID (`id`). Because it lives
in the configuration, `terraform plan` can show exactly what will be adopted ("1 to import") before
anything is written to state. That is why teams prefer it to the one-off `terraform import` command:
the import gets reviewed, versioned and repeatable across workspaces.

Both fields can be wrong in different ways:

- **`to`** has to match an existing resource address, including `for_each` keys such as
  `random_integer.room["north"]`. A wrong name fails during plan with "Configuration for import
  target does not exist".
- **`id`** has a provider-specific format. A wrong value either fails ("Cannot import non-existent
  remote object") or, as here, imports something slightly different from the code and shows up as a
  replacement. `random_integer` stores its bounds, and `min`/`max` force replacement when they differ
  from the configuration.

An import block does nothing on `plan`; the adoption happens on `apply`. After it has been applied
you can leave the block in place (it becomes a no-op) or delete it.

Practical routine: read the provider's import section, write the block, run `plan`, read every
`# forces replacement` line, and only then `apply`. A plan that wants to replace an object you are
importing is a signal that your code and the real object disagree.
