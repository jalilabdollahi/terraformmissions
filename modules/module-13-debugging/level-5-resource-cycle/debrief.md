# Debrief - cycles are about data, not order

Terraform builds a graph: every reference from one block to another is an edge ("B needs A first"). The graph must
be a DAG, a directed graph without loops. When two resources reference each other, neither can be first and Terraform
stops at plan time with `Error: Cycle`, listing the participants (sometimes with hidden helper nodes, like local values
or `(close)` vertices, when the loop is longer than two).

The way out is always the same question: *which of these references really needs a value that only exists after the other
resource is created?* Often one of the two does not. Here the roster needs the schedule's checksum, which is only known
after the schedule is rendered, so that edge is real. The schedule only needs the roster's file *name*, which is an
input you wrote yourself. By moving that name to a `local`, the second edge disappears.

Common real-world versions of this loop: two security groups that reference each other's IDs in rules (solution:
standalone rule resources), a resource and its monitoring alarm that point at each other, or a module output fed back into
its own input. In each case the fix is to split the mutual reference into "creation" and "wiring", or to share a
value that is known early.

Remember that `depends_on` cannot cure a cycle. It adds edges; it never removes them.
