# Debrief - the graph is the contract

Terraform decides what to do first by building a dependency graph from your references (and `depends_on`). Everything else is
parallel: by default up to ten operations run at once. If something needs another thing first, the graph must contain an edge,
or you have a race. Races hide, because they depend on timing: a script that needs a file works on the second apply, on a laptop, or
with `-parallelism=1`, and fails on a fresh CI machine.

`terraform graph` prints the graph in DOT format (pipe it to `dot -Tsvg` if Graphviz is installed). Read an arrow `A -> B`
as "A depends on B". Useful things to look for:

- **A resource with no arrows to the thing it uses**: a hidden dependency, typically a provisioner, `external` data
  source or `local-exec` that touches something not mentioned in its arguments. Add a reference or `depends_on`.
- **Hubs**: resources with many dependents. Replacing one forces its dependents to be re-evaluated, so they are where blast radius
  concentrates.
- **Long chains**: they limit how parallel an apply can be. A chain of 40 means 40 sequential steps no matter how high `-parallelism` is.

Prefer an implicit dependency (using an attribute of the other resource) when the dependent really consumes a value, and `depends_on`
when the dependency is only about ordering. `terraform graph -type=plan` and `-type=apply` (with a plan file) show the graph for a
concrete operation. Sleeping or lowering parallelism only moves the race.
