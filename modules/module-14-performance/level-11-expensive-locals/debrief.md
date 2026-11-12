# Debrief — compute once, name it, reuse it

Terraform expressions are evaluated where they are written. If twelve resources contain
`jsondecode(file("shards.json"))`, the file is read and parsed twelve times per plan, and again for
every refresh and apply. For a catalogue of 40 shards nobody notices; for 40,000 shards the repeated
parse, the repeated list comprehension and a repeated `sha256(jsonencode(...))` dominate the run.

A `locals` block is the right home for such values: it is evaluated once per run and referenced by
name. The side effects are good too:

- one place to change the file name or the decoding rule;
- shorter, more readable resources;
- consistent results: the audit file and the summary cannot disagree about the checksum.

The mission's acceptance test is a **byte-identical plan**: after refactoring for performance, the plan
must show no changes. If it does, either you changed the behaviour or you made a mistake in
the transformation. Always prove a performance refactor changes nothing else.

Don't hoist everything blindly: values that depend on `each.key` stay inside the resource, and cheap
expressions are better inline than hidden behind a name. Related levers on large configurations:
avoid `data` sources inside loops, load files once, use `-refresh=false` for local iteration
and split huge states.

Real-world takeaway: if the same non-trivial expression appears more than once, give it a name in
`locals`, then check that the plan is unchanged.
