# Solution guide

1. `terraform plan` fails: `Error: Instance cannot be destroyed` for `random_pet.shelf_label`, with
   `Resource random_pet.shelf_label has lifecycle.prevent_destroy set, but the plan calls for this
   resource to be destroyed.`
2. Why a destroy? `prefix` forces replacement (`# forces replacement` in the plan). Replacement is
   destroy-and-create, and prevent_destroy forbids it.
3. Decide. The mission says the label is cosmetic and should follow the rename, while the ledger is the
   permanent record. So remove `prevent_destroy` from the shelf label only; the ledger keeps it.
4. `terraform apply`. Check `terraform output shelf_label` starts with `bunker-`, and that the ledger id in
   `vault/catalogue.txt` is unchanged.
