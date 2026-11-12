# Common mistakes

- **Reversing `from` and `to`.** `from` is the address that exists in the state today (the old name).
- **Quoting the addresses.** `from = "random_id.zip_pass"` is a syntax error; moved addresses are references, not strings.
- **Moving only one of the two resources.** The unmoved one is destroyed and recreated, and a new sign with a new code is written.
- **Running `terraform state mv` instead.** It works, but the mission is about recording the rename in code so every environment inherits it.
- **Renaming the blocks back.** The plan is clean, but the cleanup commit is undone.
