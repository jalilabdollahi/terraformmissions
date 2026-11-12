# Debrief - read the trace, not just the error

Terraform's normal error output is deliberately short. It names the resource and quotes whatever the provider
returned, but it says nothing about *which phase* the failure came from or *which binary* produced it. Two
environment variables turn that around:

- `TF_LOG=TRACE` (or `DEBUG`, `INFO`, `WARN`, `ERROR`) switches on logging.
- `TF_LOG_PATH=./tf.log` writes it to a file instead of flooding the terminal. Without it the log goes to stderr.

In a trace, every call from core to a provider is a gRPC request, logged with `tf_rpc=`. The ones worth knowing are
`ValidateResourceConfig` and `PlanResourceChange` (the plan phase) and `ApplyResourceChange` (the apply phase).
Telling those apart tells you immediately whether you are hunting for a configuration problem (caught early) or an
environment/ordering problem (only visible when Terraform really touches the world). Provider bug reports also ask
for the exact plugin version, which the `starting plugin` line prints.

The root cause here was an everyday mistake: a path built from a *file's* name as if it were a directory. The
provider's file write failed with `not a directory` only at apply time, because at plan time the file did not
exist yet and Terraform cannot know what the filesystem will look like.

Practical advice: keep traces out of version control (they can contain secrets from provider calls), search them with
`grep -n "ERROR\|tf_rpc="`, and use `TF_LOG_CORE` / `TF_LOG_PROVIDER` when you only care about one half.
