# Split and Join

## What Was Broken
`split(",", "a;b;c")` looked for commas in a string that uses semicolons. Since no commas were
found, the entire string was returned as a one-element list: `["a;b;c"]`.

## The Fix
```hcl
parts    = split(";", local.raw)     # ["a", "b", "c"]
rejoined = join("-", local.parts)    # "a-b-c"
```

## split() and join()
```hcl
split(",", "a,b,c")       # → ["a", "b", "c"]
join("-", ["a", "b", "c"]) # → "a-b-c"
join("", ["a", "b", "c"])  # → "abc"
```

`split` and `join` are inverses: `join(sep, split(sep, s)) == s`

## Why It Matters
Split/join operations are common when processing tag values, environment variables, or
CSV-style configuration strings. A wrong separator is a silent bug — no error, just wrong output.