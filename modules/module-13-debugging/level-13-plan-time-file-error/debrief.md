# Debrief - plan-time versus apply-time

Terraform evaluates your configuration twice: while planning and while applying. Functions that read the outside world, `file()`,
`templatefile()`, `fileexists()`, `filebase64()` and friends, run during evaluation, so they see the disk as it is *at that moment*. A
file that another resource creates in this same run does not exist yet at plan time, so the plan fails with "no file exists".

What makes this bug nasty is its fickleness. The second time you run Terraform, the file is already there from the first
apply, so everything works. The fresh clone on a colleague's laptop, or the CI runner, fails. The validator for this level plans from
a scratch copy for that reason.

Choose by where the data comes from:

- Data you **write in Terraform** (locals, resource arguments): reference it directly, as `local_file.x.content`. It is known at plan
  and adds the dependency automatically.
- Files **shipped in the repo** (templates, scripts): `file()` and `templatefile()` are right, because they exist before the run.
- Files **produced by another tool or earlier apply**: use a `data` source with `depends_on` (so the read is deferred to apply
  time) or restructure so the generation and the consumption are separate configurations.

Related symptom: `data "local_file"` reading something not yet created also fails if its path is known at plan time. When unsure,
ask "will this file be on disk before `terraform plan` starts?"
