# Common Mistakes

- **Unquoted string keys in `to` addresses** — always quote for_each string keys.
- **Wrong key order** — ensure count index N maps to the correct string key.
- **Forgetting a moved block for one instance** — all instances need a `moved` block.
- **Running apply before plan** — always verify the plan shows no unexpected destroys.