# Debrief — Terraform only knows the dependencies it can see

Terraform orders work by a dependency graph built from references: if a resource uses `module.a.some_output`, it
waits for module `a`. Here the contract between the two modules is a *file on disk*, and the path is passed as a
plain string. There is no reference, so no edge, and Terraform may evaluate the two modules in either order — or
in parallel. Worse, a `data` source is normally read during **plan**, which happens before anything is applied,
so on a first run the log is not yet there.

`depends_on` is the tool for exactly this: dependencies that exist in the real world but not in the expression
graph. For a data source (or a module containing one), it also changes *when* the read happens: if the thing it
depends on has pending changes, the read is postponed to apply time. That is why the schedule now follows the
new thickness in a single apply instead of lagging one run behind.

Use it sparingly. `depends_on` makes plans less precise, because everything in the dependent module is treated as
possibly changing whenever the dependency changes. Whenever you can, pass a real value instead: an output of
the chiller used as the resurfacer's input is both an implicit dependency and documentation of the data flow.

**Takeaway:** when two modules communicate through files, scripts, remote systems or timing, add `depends_on`
to the consumer — and prefer wiring a real output into an input where you can.
