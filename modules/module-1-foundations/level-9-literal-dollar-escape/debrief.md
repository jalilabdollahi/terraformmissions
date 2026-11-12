# Debrief — Dome Three Watering

**What broke.** Terraform's string templating and the shell's variable expansion share the same
syntax, `${...}`. When Terraform writes a shell script, it reads every `${` as one of its own
expressions. `${HOME}` looks like a reference to something named HOME, and `${PUMP_SECONDS:-30}` is not a
valid Terraform expression at all, so plan fails before anything is written.

**The escape.** `$${` means "a literal `${`". The extra dollar sign is consumed by Terraform, and the
file receives exactly one. The same trick for template directives uses `%%{`. The bare form `$PUMP_LOG`, with no
brace, never triggered anything, which is why only some of the lines had to change.

**Who expands what.** In this level, two actors work at two different moments. Terraform
expands `${var.bay}` while it is planning; the shell expands `${HOME}` later, on the greenhouse
controller. Keeping that split clear is the heart of any templated script, cloud-init file, or
Dockerfile written from HCL.

**Real-world takeaway.** Generating shell, nginx config, Helm values, or GitHub workflow
files from HCL almost always needs `$${`. If a script has a lot of shell syntax, keep it in a
separate file and render it with `templatefile()`, escaping only the few shell expressions that
clash, or pass the dynamic values as environment variables.
