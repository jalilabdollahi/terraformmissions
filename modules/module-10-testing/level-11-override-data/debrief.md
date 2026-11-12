# Debrief - freezing the outside world

A data source reads something Terraform does not manage: a file, an API, a cloud lookup. In a plan-mode
test it is read for real, so the test depends on the environment: missing file, no credentials, a value
that changes tomorrow. `override_data` cuts that tie. You name the data source, give it `values` for its
computed attributes, and Terraform uses them instead of calling the provider.

Two things go wrong in practice. First, **forgetting the override** for one scenario: that run reads the real
thing, and fails with a provider error that looks unrelated to your test. Second, **a key that does not
exist** in `values`. Terraform accepts it and generates data of the right type for the attributes
you did not set, so you get random garbage reaching your code. The symptom is almost always in a
parsing function like `tonumber`, `jsondecode`, or `regex`, far from the cause.

Because override blocks may be placed in a run, each scenario can declare its own reading: calm, gale and
the exact boundary value. Boundary scenarios are especially valuable. The `gusty_edge` run sets exactly 18
knots to prove the rule is strictly less-than, which a single "typical" reading never would.

Real-world takeaway: when logic depends on outside data, test the logic with overridden data and the
data source configuration separately. Check attribute names in the provider docs, and write at least one
test at the boundary of every threshold.
