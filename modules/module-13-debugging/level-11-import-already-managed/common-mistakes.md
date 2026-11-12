# Common mistakes

- **Running `terraform apply` to "clean up" the destroy.** With real infrastructure that deletes the shared object; the
  mission is to forget the duplicate without destroying anything.
- **Running `terraform state rm random_integer.cabinet_code`.** That removes the entry the configuration owns, and the next plan
  wants to create a new cabinet code.
- **Adding `resource "random_integer" "cabinet_dup"` back to the code.** It makes the plan look clean but keeps two registrations.
- **Re-importing with an `import` block.** That is exactly how the duplicate was created.
- **Editing `terraform.tfstate` by hand.** Use `terraform state rm`; it handles serials and locking.
