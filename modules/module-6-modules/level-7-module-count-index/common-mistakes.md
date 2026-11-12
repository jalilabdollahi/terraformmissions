# Common mistakes

- **Using `module.post[0].label` for the labels output.** One element is not a list of all labels.
- **Leaving `module.post[var.posts_total]` as it was.** It is one past the end; plan fails as soon as it is evaluated.
- **Writing `number = count.index`.** Labels would start at LP-00; the mission says numbering starts at 1.
- **Dropping `count` and calling the module three times by hand.** It cannot follow `posts_total`.
