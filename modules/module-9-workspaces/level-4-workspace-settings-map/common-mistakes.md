# Common mistakes

- **Hard-coding `local.layouts["dev"]`.** The error disappears, and so do the separate settings for prod.
- **Copying dev's values into qa.** The plan works, but the objective names specific numbers for qa.
- **Replacing the lookup with a ternary on `terraform.workspace == "prod"`.** It works for prod and anything
  else becomes dev. Two environments now share one entry and the map is dead code.
- **Creating a different workspace.** `terraform workspace select dev` makes the error vanish, because dev
  exists in the map. The code is still broken for qa.
