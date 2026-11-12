# Debrief - helper runs as fixtures

Real tests often need a world to exist first: a file to read, a directory layout, a seed record. The test
framework's answer is the **helper (or setup) module run**: an early `run` whose `module { source }` block
points at a tiny module that creates the fixture, and whose outputs later runs consume with
`run.<name>.<output>`. The code under test stays free of test-only logic, and the fixture is created with
the same Terraform you already know.

Two properties make this pattern work. First, a helper **must apply**: a plan describes the fixture but
creates nothing, so any later run that reads it from disk fails. Second, at the end of the file Terraform
destroys state in **reverse order**, so the code under test is torn down before the fixture it depends on,
and the fixture cleans up after itself. That is why no stray lineup remains.

Note what a helper run without a `module` block does: it simply runs the root configuration again, which is
rarely what you meant and fails with confusing "missing variable" errors from the code under test.

You can have as many helpers as you like, each with its own variables, which is how `setup_long` creates a
different fixture for the double-header scenario. Keep helper modules dumb: no assertions, no logic beyond
shaping the fixture.

Real-world takeaway: put fixtures in their own module under `tests/`, name the helper runs `setup...`, make
them apply, and pass their outputs forward instead of duplicating paths in every test.
