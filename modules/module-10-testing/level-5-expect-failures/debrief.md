# Debrief - telling Terraform which failure you want

Variable validation is a guardrail, and guardrails deserve tests that try to cross them. Normally a failed
validation aborts the plan and the run fails. `expect_failures` flips that: you list the checkable objects
that are *supposed* to fail, and the run passes only if exactly those fail and nothing else does.

Addresses are literal references, not strings and not declaration syntax. `var.dose_mg` targets the input
variable's validation. Other valid targets are `check.<name>`, `output.<name>`, and resources or data
sources for their preconditions and postconditions (see the last level of this module). Terraform 1.17 still
tolerates a quoted `"var.dose_mg"` but warns it is deprecated; skip the quotes.

Two failure modes are demonstrated here. `variable.dose_mg` names nothing real, so the validation error
that fired was unexpected and the expected one never appeared. And a copy-pasted run expecting the wrong
variable fails twice over: one unexpected failure, one missing expected failure. Terraform reports both,
which is exactly the pair of errors you should look for.

Real-world takeaway: for every validation rule add a run that violates it and expects that precise
failure, plus a happy-path run. If somebody later relaxes the rule, the negative test breaks and the
change becomes a conscious decision instead of a quiet one.
