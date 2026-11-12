# Common mistakes

- **Changing the variable to `list(string)`.** The error disappears, but the mission wants a set (genres
  are unique and unordered), and `[0]` would then return `poetry`, the first typed, not the alphabetical first.
- **Using `tolist(var.donated_genres)[0]` without `sort`.** It returns something, but the order is not
  guaranteed to be alphabetical, so the answer may not be `astronomy` for other sets.
- **Hard-coding `"astronomy"` as the featured genre.** The window card would never change when the donation
  list does.
- **Using `one(var.donated_genres)`.** That only works for sets with at most one element and errors for four.
