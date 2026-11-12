# Debrief — sensitive hides it, ephemeral never stores it

Terraform's `sensitive` flag is a display feature: the value is still written, in plain text, to the state file and into saved plan files. That has been
the biggest surprise for newcomers, and it is why state backends need encryption and strict access control.

Terraform 1.10 added **ephemeral values**: input variables (and outputs of child modules, ephemeral resources and locals derived from them) that exist only while Terraform runs.
They are never written to state or plan files. The compiler enforces the rule: an ephemeral value can flow only into other ephemeral contexts — provisioners and connection blocks, provider configuration,
write-only resource arguments, ephemeral resources — and Terraform produces an error if you try to put one into an ordinary argument that must be persisted.

For this mission that restructuring is the lesson. The provisioner needs the token at run time, so it reads the variable directly. The stored `input` carries only what has to be remembered.
In practice, the best uses are provider credentials (so tokens are not in state) and write-only attributes such as database passwords in provider versions that support them.

Two limits: an ephemeral variable cannot be given to anything that records it, and the receiving program may still log it. Also remember that when the provisioner only runs at creation, rotating the token
does not re-run it unless something else triggers replacement.
