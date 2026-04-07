# Common Mistakes

- **Omitting `terraform.` prefix** — always write `terraform.workspace`, never just `workspace`.
- **Using `terraform.env`** — this is a deprecated alias; prefer `terraform.workspace`.
- **Declaring a variable named `workspace`** — while valid, it shadows the intent and creates confusion.