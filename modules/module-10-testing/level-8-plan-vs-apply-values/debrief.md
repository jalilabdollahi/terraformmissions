# Debrief - what a plan can and cannot know

During `terraform plan`, anything computed by a provider at creation time is marked "known after apply":
random values, generated IDs, timestamps, server-assigned addresses. A `command = plan` run can still
evaluate assertions, but only on values that are already known. When an assertion touches an unknown
value, Terraform does not guess; it reports `Unknown condition value` and tells you to either remove the
dependency or use an apply run. (The message also mentions `override_during = plan`, which is the mock
route, covered later.)

The temptation is to flip every run to `apply`. That works, but it spends time and, with real providers,
money. A better design splits claims by what they need: configuration logic (labels, counts, names built
from variables) is a plan-run claim; "what the provider returned" is an apply-run claim. Tests built this
way stay fast, and when one fails it is clear which kind of claim broke.

For random values you rarely assert the value itself, only its *shape*: a length, a regex, a range. Those
are stable properties of the code. `can(regex(...))` makes a clean boolean condition and a readable
failure.

Real-world takeaway: if you see `Unknown condition value`, the test is asking the plan something it
cannot know. Choose apply for that run, and keep every other run on plan.
