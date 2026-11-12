# Common mistakes

- **Running `terraform apply` to see what happens.** It destroys the retired log's file, draws a new operator name and a new silo number.
- **Importing the silo number with the wrong ID.** `random_integer` needs `value,min,max`; a wrong min or max imports an object that the plan wants to replace.
- **Using `state rm` for the rename.** Forgetting `random_pet.harvester` makes Terraform create a brand-new operator; `state mv` keeps the name.
- **Deleting the gauge log by hand "to make the plan clean".** The auditors need that file.
- **Adding `moved`, `removed` or `import` blocks.** They solve the same problems declaratively, but this mission is about the state CLI, so the validator rejects them.
