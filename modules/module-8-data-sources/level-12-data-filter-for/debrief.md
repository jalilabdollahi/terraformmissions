# Debrief — filtering and grouping data with `for`

Data sources return what exists; they rarely return what you need. Terraform's answer to "give me
only some of it" is the `for` expression with an `if` clause. The shape of the brackets decides the
result: `[for x in list : f(x) if cond]` builds a list, `{for x in list : k(x) => v(x) if cond}`
builds an object. The condition is evaluated first, so only matching items contribute.

Two things went wrong in this mission, and both are everyday experiences when working with
decoded JSON.

**The wrong field name.** After `jsondecode`, each tool is a plain object and Terraform is strict
about attributes: asking for `tool.state` when the file says `status` is an error rather than a
quiet null. That strictness is useful; it catches typos at plan time. For fields that are genuinely
optional, see the null-guard mission.

**Duplicate keys.** An object cannot hold two values under one key, so mapping tools to their class
fails as soon as the class repeats. Adding `...` after the value expression turns on grouping mode:
every key collects a list of all values that produced it. The filter and the grouping combine freely;
the `if` removes retired and in-repair tools before grouping, so a class whose tools are all
unavailable (decor here) simply disappears.

Filtering in Terraform code is cheap, deterministic and easy to review; prefer it to asking the data
source for a pre-filtered answer you cannot see. And since the register is the source of truth, the
validator changes it and expects the rota to follow.
