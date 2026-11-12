# Debrief — what the names after "for" mean

A `for` expression declares its own variables between `for` and `in`, and the meaning depends on how
many you give it and what you loop over:

| Loop over | One name | Two names |
|---|---|---|
| list or tuple | the element | `index, element` |
| map or object | the value | `key, value` |
| set | the element | not allowed |

The surprising row is the first one. In many languages you would write `for item, index`, and so
a Terraform author with that habit writes `for scent, position in var.scents` and gets the index in
`scent`. The error here is loud because `position + 1` needs a number and receives text. When the
types happen to line up (a list of numbers, or only string formatting), the swapped version runs
and produces silently wrong output.

The second failure shows scoping. The names declared after `for` are the only names the body can use,
besides ordinary references to variables, locals and resources. Misspelling an iterator gives
"Unknown variable". It is a good reminder that the iterator is local to the expression, so `batch`
does not exist outside the brackets.

Brackets matter, too: `[for ...]` builds a list, `{for ... : k => v}` builds a map.

## Real-world takeaway

Whenever you copy a for expression from a map loop to a list loop (or the other way round), re-read
the iterator names. Check one element in `terraform console`; it takes ten seconds and avoids a
mislabelled batch of jars or, in real life, mis-numbered servers.
