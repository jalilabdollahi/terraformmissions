# Common Mistakes

- **Empty `error_message = ""`** — not allowed; Terraform will reject it.
- **Generic messages like `"assertion failed"`** — technically valid but unhelpful.
- **Not interpolating the actual value** — adding `${output.count}` to the message makes failures
  immediately obvious without re-running in verbose mode.