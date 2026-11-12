# Common mistakes

- **Changing the condition to `terraform.workspace != "dev"`.** Prod now works, but staging is also treated
  as production and gets the pager. The validator checks staging.
- **Setting `is_prod = true`.** Every workspace becomes prod. Never replace a condition with a constant.
- **Renaming the workspace to `prd`.** The mission is about the code; the workspace names are fixed as dev,
  staging and prod.
- **Editing only the `count`.** The retention local uses the same flag, so both would have to be patched
  individually. Fix the flag once.
