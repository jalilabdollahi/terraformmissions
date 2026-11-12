# Debrief: a map keyed by workspace is a contract

Settings maps keyed by `terraform.workspace` are the most common way to make one configuration serve
several environments. The pattern has one defining property: a missing key is an *error*, not a default.
That is a feature. If somebody creates a workspace called `qa` and forgets to add settings, Terraform
stops at plan time instead of quietly inventing values.

The alternatives each trade that safety for convenience:

- `lookup(local.layouts, terraform.workspace, local.layouts["dev"])` makes every unknown workspace
  behave like dev. Great for throwaway preview workspaces, bad if somebody typos `prdo` and gets a dev-sized
  production;
- `try(local.layouts[terraform.workspace], null)` followed by a validation check keeps the error but gives
  a better message;
- a `precondition` on the first resource can print a friendly "unknown workspace" explanation.

For real teams, remember that adding a workspace is a *two-step* change: `terraform workspace new qa` in the
CLI, and a code change to the map. The map belongs in review. The CLI step leaves no trace.

**When workspaces are the wrong tool:** once the map grows large (twenty keys, nested objects, secrets),
you are maintaining an environment registry inside one file. Per-environment `.tfvars` files, or one small
root module per environment calling shared modules, scale better and give each environment its own
history in version control.
