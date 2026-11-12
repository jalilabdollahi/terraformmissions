# Post-mortem - breaking up the float warehouse state

**Timeline.** Week 1: deploy locks block lighting twice. Week 2: CAB approves the split. Week 3: the three stacks are
scaffolded. Cut-over: state is moved object by object, outputs are published in dependency order, the monolith is retired.

**Root causes.**
1. One state meant one lock and one blast radius for unrelated teams.
2. Scaffolding new configs does not move anything: Terraform identifies an object by address inside a particular state, so
   an empty new stack would happily create a second float warehouse.
3. The cross-stack coupling existed only inside the monolith (direct references). Splitting turned each reference into an
   interface that must be exported and published.

**How Terraform behaves.** `terraform state mv -state=A -state-out=B addr newaddr` removes the entry from A and writes it
into B, optionally under a new address; nothing real is touched. Writing into an existing `-state-out` appends. A resource
name without an index moves every instance. `terraform_remote_state` reads only the outputs recorded in the other state
file, and outputs are stored when an apply (even one with no resource changes) runs, so producers must be applied first.

**Prevention.**
- Write the ownership table before splitting and review it with every team involved.
- Split in dependency order and finish each stack with a clean plan before moving to the next.
- Keep the old state until all stacks plan clean, and take a backup of it first.
- Export only the values consumers need, as outputs, and treat them as contracts.
