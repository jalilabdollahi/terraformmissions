# Debrief — absent is not the same as null

Data coming from outside Terraform is rarely tidy. This guest list has three different states for the
"diet" field: a real value, a key that is simply missing, and a key whose value is `null`. Terraform
treats them differently, and each needs its own handling.

- **Missing key.** After `jsondecode`, every guest is an object with exactly the keys present in the
  JSON. Reading `g.diet` where there is no such key is an *error*, not a null. `try(g.diet, null)`
  (or `lookup(g, "diet", null)`) turns the error into a value you can test.
- **Explicit null.** The key exists with value `null`. Reading it works, so `try(g.diet, "x")` returns
  null, not "x", and you cannot interpolate a null into a string ("argument must not be null").
- **Defaulting.** `coalesce()` returns its first argument that is neither null nor an empty string,
  so `coalesce(try(g.diet, null), "no restrictions")` covers both cases and also treats an empty
  string as "nothing".

Two cautions. `try()` swallows *any* evaluation error, including typos in the attribute name, so keep
the expression inside it as small as possible and never wrap a whole block of logic. And decide on
the default deliberately: "TBA" for a table is honest, whereas silently defaulting a dietary
restriction to "none" might be unsafe; here the card text makes that default visible.

The validator exercises these paths by editing the list: a null table, a guest with neither field and
a numeric table must all produce sensible cards.
