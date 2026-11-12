# Common mistakes

- **Interpolating `${jsonencode(each.value)}`.** It plans, but the slip then contains raw JSON instead
  of the required sentence.
- **Changing the variable to `map(string)`.** The defaults are objects and would no longer fit - and
  the box total in the output breaks.
- **Indexing like a list: `each.value[0]`.** Objects are accessed by attribute name.
- **Using `each.key.volunteer`.** The key is just the string `early`; the data lives on `each.value`.
