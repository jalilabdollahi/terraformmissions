# Debrief - where test inputs come from

A module under test is just a root module, and its required variables must get values from somewhere.
In `terraform test` there are four layers, from weakest to strongest: defaults in the code, `-var` and
`-var-file` on the command line, a file-level `variables {}` block, and a `variables {}` block inside a
single `run`. Later, narrower layers win. That is why this level's second scenario can swap `players` for
five names while still inheriting `club` from the top of the file.

Two syntax lessons are packed in here. First, the block form: `variables { x = 1 }`, with no equals sign.
Terraform's own message ("Did you mean to define a block of type variables?") gives it away. Second, the
block must be at the top level of the file if you want it shared. Pasted inside one `run`, it only feeds
that run and the next scenario will fail with "No value for required variable".

File-level variables keep scenarios short and make the one thing each scenario changes stand out. A good
habit is to put a realistic baseline at the top and let every `run` override only what its name promises:
`odd_roster_gets_bye` overrides the roster and nothing else.

Real-world takeaway: do not duplicate the same ten variables in every run block. Put the baseline in a
file-level block, override minimally, and let the diff between a run and the baseline be the story of the
test.
