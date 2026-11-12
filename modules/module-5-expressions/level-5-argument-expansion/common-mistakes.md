# Common mistakes

- **Hard-coding `max(12.5, 48, 31.2, ...)`.** It matches today's data and ignores any new site.
- **Adding `...` to only `max`, not `min` or the per-site call.** Each unexpanded call is a separate
  error; fix all three.
- **Using `sort()` and indexing `[0]`.** `sort()` sorts strings, so 15 comes before 7.75; numeric
  sorting is not what you think.
- **Putting `...` outside a function call**, for example in a list literal `[local.all_depths...]`.
  Expansion is valid only as the final function argument.
- **Calling `max(flatten(values(var.cores)))` and expecting it to work.** `flatten()` returns a list,
  which still needs the `...`.
