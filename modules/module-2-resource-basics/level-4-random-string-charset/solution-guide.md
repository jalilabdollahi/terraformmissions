# Solution guide

1. `terraform apply` and `terraform output card_number`: something like `Zf!7qW#k2Lp@9rXd`. Too long, and it
   contains capitals and punctuation, so it breaks the rule written in the config comment.
2. In the docs for `random_string`, `upper`, `lower`, `numeric` and `special` all default to `true`.
3. Edit the resource: `length = 10`, `upper = false`, `special = false`.
4. `terraform apply`. The resource is replaced (these arguments force a new value) and the
   card file is rewritten with the new number.
5. Run `terraform output card_number` and check it is 10 characters of `a-z0-9`.
