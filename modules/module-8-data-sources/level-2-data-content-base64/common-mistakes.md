# Common mistakes

- **Switching only the writing side.** `content_base64 = data.local_file.rose.content` feeds text
  where base64 is expected and produces a corrupt file or a decode error. Both sides need the base64 pair.
- **Running `terraform apply` again and calling it fixed.** The apply "works" every time and the
  plan is never clean; the resource is replaced on each run.
- **Replacing the data source with `file()`.** `file()` is text-only and fails or mangles on
  binary data. The mission also wants the engraving read through the data source.
- **Using `lifecycle { ignore_changes = [content] }`.** It hides the symptom, but the copy is
  not guaranteed to be byte-identical and a new engraving would never be picked up.
