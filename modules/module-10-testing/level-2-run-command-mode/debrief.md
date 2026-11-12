# Debrief - choose the command for the claim you make

Every `run` block executes either `terraform plan` or `terraform apply`. The default is `apply`, which is
why many test files never mention `command` at all. A `plan` run is cheaper and creates nothing, so it is
the right tool for questions like "what does this output evaluate to?" or "does the validation reject this
input?". An `apply` run is needed when the claim is about the world after creation: a file on disk, a value
the provider only computes at apply time, or the behaviour of a second run that builds on the first.

The failing run in this level made an after-apply claim (the recipe file exists) with a plan-only command.
Terraform did exactly what it was told: it planned, found nothing on disk, and the assertion failed. The
test was not flaky and the code was not wrong; the test described a different experiment from the one it
ran.

Remember that apply runs are real. At the end of the file Terraform destroys everything the runs created,
in reverse order, which is why `terraform test` leaves your directory clean. If a provider is slow or
costs money, keep `apply` runs few and focused, and use `plan` (or mocks, later in this module) for the
rest.

Real-world takeaway: write the sentence "after ___ , X is true" first. If the blank is "apply", the run
must be an apply. If it is "plan", prefer plan so your suite stays fast.
