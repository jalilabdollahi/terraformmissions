# Common mistakes

- **Passing the list of files with `tolist(fileset(...))`.** `for_each` rejects lists; it needs a
  set or a map.
- **Only fixing the path.** The splat error comes next, and the keys would still carry `.txt`.
- **Listing the three sheets by hand in a map.** The board would miss any sheet added later, and
  the validator adds one.
- **Using `count` instead of `for_each`.** It works for a fixed list but changes the data source to a
  list of instances and loses the name-keyed addressing the mission asks for.
- **Stripping the extension with `replace(key, ".txt", "")`.** Works here, but `trimsuffix` states
  the intent and does not touch a `.txt` that appears in the middle of a name.
