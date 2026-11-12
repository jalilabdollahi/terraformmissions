# Debrief — argv is public, the environment is (much) less so

On a shared machine, the command line of every process is readable by every other user. Anything you
interpolate into a `local-exec` `command` string therefore leaks to `ps`, to audit logs that record
process starts, and to any CI log that echoes commands. Terraform's own output tries to help: when a
sensitive value is in the command it prints *output suppressed due to sensitive value in config*,
but that only hides the log. The process arguments are already out.

The `environment` map hands values to the child through its environment block instead. That block is
readable only by the process owner (and root), and it is the same convention every twelve-factor tool already
follows. The script reads `$LANDING_PASSWORD`, and Terraform still redacts the variable everywhere it prints.

Two follow-ups for real projects. First, a provisioner is a last resort — prefer a provider or a dedicated
resource where one exists. Second, the secret still reaches the child, so the child must not echo it,
write it to a world-readable log, or pass it on as an argument to the next tool. Treat the hand-off as
a boundary and check both sides of it.
