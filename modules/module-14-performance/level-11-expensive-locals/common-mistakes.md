# Common mistakes

- **Moving only the checksum into a local.** The file is still decoded in every resource; the validator
  counts both `jsondecode(` and `sha256(`.
- **Storing the decoded list in a `variable` default.** Variable defaults cannot call `file()`; the
  value has to be computed in `locals`.
- **Changing the file contents "while refactoring".** Any difference in the generated text shows up as a
  planned change, and the puzzle checksum no longer matches the original.
- **Defining one local per resource that decodes the file again.** That only renames the repetition;
  there must be exactly one decode.
