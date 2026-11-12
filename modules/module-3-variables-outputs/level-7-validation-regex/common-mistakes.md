# Common mistakes

- **Deleting the validation block.** The plan passes, but the box office loses its safety net — the
  validator submits malformed codes and expects them to be rejected.
- **Loosening the pattern to `.*` or dropping the anchors.** `ORC-2041x` and `orc-2041` would then be
  accepted, which is exactly what the regex was supposed to prevent.
- **Changing the default to `ORC2041`.** That matches the buggy pattern, but the split on `-` in the
  locals then fails and every real code in the building has a hyphen.
- **Editing the error message** to say the hyphen is not wanted. The message was right; the code is
  what the building prints on tickets.
