# Debrief — Crumb And Kettle

**What broke.** HCL is built from blocks: a type, optional labels, and a body wrapped in `{ }`. The
`oven_schedule` resource opened a body and never closed it. Terraform's parser reads the whole file
before it plans anything, so one missing brace stops every command, not only the resource you were
editing.

**Why the error points where it does.** The parser cannot know a brace is missing until it runs out of
file. It then reports the block that is still open, using the line where that block *began*. That is
why the message mentions `line 20` even though the real mistake is on the last line. Read the error
backwards: which block is still open?

**How to find these faster.**
- Run `terraform validate` early and often; it is instant and needs no cloud access for syntax errors.
- Let your editor match braces, and run `terraform fmt`. If indentation drifts after a certain
  line, that is usually where a block was left open.
- When the error is at the end of a file, look at the *last* block you touched.

**Real-world takeaway.** A syntax error is the cheapest failure you will ever see: no state was
touched and nothing was created. Wire `terraform fmt -check` and `terraform validate` into a
pre-commit hook or CI job so a 4 a.m. edit is caught before it reaches the main branch.
