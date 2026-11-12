# Debrief — .gitignore is part of your security boundary

The files Terraform leaves around are mostly dangerous. State files contain every attribute of every resource in plain text, including passwords, private keys and tokens, even when
the CLI redacts them. Saved plan files embed variable values. `*.tfvars` files are where people put secrets they were told not to put in `.tf` files. `crash.log` can dump the same values on a bad day.
Committing any of them hands the secret to everyone with read access to the repository, forever, because git history is permanent.

There are two files that people get wrong in opposite directions. `.terraform/` must be ignored (it is large, platform-specific provider binaries), but `.terraform.lock.hcl` must
be committed: it pins provider versions and checksums so that every developer and CI run insculptures the same ones. Likewise ignore secret variable files by pattern but keep a
`terraform.tfvars.example` documenting the shape.

Remember that `.gitignore` only affects *untracked* files. If a secret was committed already, remove it from the index, purge it from history if you can, and treat the secret as compromised.
Backstops help: pre-commit hooks or CI secret scanners, and a remote backend so that state never lives in the working tree in the first place.
