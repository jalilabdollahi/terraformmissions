# Common mistakes

- **Running `terraform untaint`.** The plan goes clean, but `flashed/van-07.stamp` never appears: the provisioner
  did not run.
- **Setting `on_failure = continue`.** The apply succeeds even though no firmware was flashed.
- **Creating `flashed/van-07.stamp` by hand.** The stamp has to come from the provisioner run that replaced the object.
- **Applying again without reading the output.** The same failure is repeated and the object stays tainted.
- **Renaming the image to match the typo.** The folder is `images/`; the config path was wrong.
