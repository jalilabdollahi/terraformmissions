# Common mistakes

- **Hard-coding `separator = "-"`.** The default path works, but the `-var slug_separator=_` override stops
  working; the mission needs both.
- **Deleting the `separator` line.** Default behaviour returns, but editors lose the ability to override it.
- **Setting the variable default to `"-"`.** It works, but it copies the provider's default into your code and it
  will silently drift if the provider ever changes; `null` says "let the provider decide".
- **Assuming `""` and `null` are interchangeable.** They are different values; arguments treat them differently.
