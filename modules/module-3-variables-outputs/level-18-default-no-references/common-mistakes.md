# Common mistakes

- **Deleting the `batch_label` variable and computing it in a local only.** The special-run override is
  lost; the check passes `-var batch_label=Anniversary-Ale` and expects it to win.
- **Hard-coding `default = "Copperkettle-batch"`.** Works for the default brewery, but then changing
  `brewery` leaves the label stale.
- **Switching the default to `""` and testing it with `var.batch_label == ""` elsewhere.** More complex and
  forgets that `null` is the idiomatic "not provided" value.
- **Updating the local but forgetting to change the resource and output** to use `local.batch_label`. They
  still read the raw variable (`null`) and print an error or empty label.
