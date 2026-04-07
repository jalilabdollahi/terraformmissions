# Common Mistakes

- **Iterating over a string** — strings in Terraform iterate character by character in `for` expressions; decode JSON first.
- **Assuming `content` auto-parses** — Terraform never auto-parses file content; always call `jsondecode()` or `yamldecode()` explicitly.
- **Filter syntax** — the `if` clause in a `for` expression uses the element itself: `for x in list : x if x.condition`.