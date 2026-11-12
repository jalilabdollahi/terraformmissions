# Debrief — Copper Kettle Menu

**What broke.** Terraform has two heredoc forms. `<<EOT` takes the text between the markers literally,
including every leading space. `<<-EOT` ("indented heredoc") strips the *common* leading whitespace from
all lines first. The menu was written with the first form but indented in the file so it looks neat
next to `content =`, and so the neat indentation ended up in the file the tablet reads.

**Relative indentation survives.** The `-` form does not delete all indentation; it deletes the
smallest amount found on any non-empty line. Here that is four spaces, so the title and last line
land at column 0 and the three dishes keep two spaces. If one line were less indented than the others,
that line would set the baseline for everyone, which is a classic reason a heredoc body suddenly looks
wrong after an edit.

**Closing marker.** With `<<-` the closing `EOT` may be indented too, which lets the whole block sit
inside nested blocks without breaking out to column 0. Interpolations such as `${var.soup}` work in both
forms.

**Real-world takeaway.** Generated config files (YAML, cloud-init, systemd units) are
whitespace-sensitive. Use `<<-` by default for anything indented inside HCL, and check the real
output with `cat -A` or a diff. For long documents, `templatefile()` with a separate file avoids the
problem altogether.
