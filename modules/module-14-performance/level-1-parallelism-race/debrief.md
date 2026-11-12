# Debrief — parallelism exposes missing edges

Terraform builds a dependency graph from references between resources. Every node whose dependencies
are finished is started immediately, up to `-parallelism` (default 10) at a time. If two resources
are *really* ordered but the configuration never says so, the order you observe is an accident: of
scheduling, of how fast a provider is, of how loaded the CI machine is. Slow laptops and
`-parallelism=1` make the accident happy; a fast runner makes it fail.

Strings are opaque. A shell command that mentions `foundry/alloy-ledger.txt` does not create an edge,
because Terraform does not parse your script. A reference such as `local_file.alloy_ledger.filename`
does. When the link cannot be expressed as a value (a provisioner that reads a side effect, an API
that needs another resource to exist), use `depends_on`.

Lowering parallelism is a legitimate tool for rate-limited APIs, and it can shave nothing off a
correct config. It is not a fix for an ordering bug: the bug is still there and returns when someone
raises the number, or when a new resource is added that changes the schedule. The same goes for
`sleep 5` in a provisioner.

Real-world takeaway: if "apply sometimes fails, a re-run fixes it", suspect a missing dependency
first. Run `terraform graph`, compare it with what actually has to happen first, and add the edge.
Then prove it by applying from scratch several times at default parallelism.
