# Debrief - runs are a pipeline

Within one test file, runs execute in order, sharing the same state. Each finished run publishes its root
module outputs under `run.<run_name>.<output_name>`, and later runs can use those values in their
`variables` blocks and assertions. That lets you test a workflow: measure, then order, then compare, with
the number from step one flowing into step two instead of being copied by hand into the test.

Two rules decide whether it works. First, order: a reference to a run that has not executed yet is not an
ordinary "unknown value", Terraform treats the file as a dependency graph and reports a cycle, which is a
confusing message the first time. Second, names: only declared **outputs** are visible, not locals, not
resources. If you want to chain a value, expose it as an output.

There is also a failure-handling consequence. If a run fails, later runs are skipped, so one broken link
in a chain hides the health of everything downstream. When reading results, always fix the earliest
failure first.

Real-world takeaway: chain runs only when the second step really depends on the first one. Independent
scenarios should stay independent so a failure points at exactly one thing, and anything a test needs
from the module should be an explicit, documented output rather than something poked out of internal state.
