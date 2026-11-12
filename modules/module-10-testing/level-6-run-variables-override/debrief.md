# Debrief - overrides obey the variable's type

A `variables {}` block inside a run behaves like `-var`: Terraform converts the given value to the
variable's declared type, and if it cannot, the run fails *before any planning*. That is why this level's
assertions never printed anything: a run with an invalid override dies at input validation and the
assertions are never evaluated.

You also met the **skipped** state. When a run fails, the remaining runs in the same file are skipped
because later runs may rely on the state or outputs of earlier ones. A summary like `1 passed, 1 failed,
1 skipped` therefore means "fix the failure first, then look again". A skipped run is not green.

Type conversion is forgiving in some directions (`"40"` becomes the number 40, `"true"` becomes a bool) and
strict in others (`"40 litres"`, a list given to a map). Do not write units into values; put them in the
variable name (`tank_liters`) or its description, and keep the value pure.

Notice too that test overrides must follow the same shape as real callers' inputs. If your test needs a
value the type forbids, the type is probably too tight for production as well.

Real-world takeaway: keep overrides tiny, typed correctly and named after the scenario, and always read
the summary line for skipped counts. A suite that skips half its runs on a CI server while exiting
non-zero for a different reason is easy to misdiagnose.
