# Common Mistakes

- **Treating string items as objects** — `item.value` only works when `item` is an object with a `value` attribute.
- **Wrong variable type** — always check whether the input is `list(string)`, `list(object(...))`, or `map(...)`.
- **Using index instead of value** — use `[for i, v in list : ...]` to get both index and value.