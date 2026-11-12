# Debrief — ephemeral values can cross module boundaries, if everyone agrees

Terraform 1.10 introduced ephemeral values, and 1.11 extended the idea to resources that exist only while Terraform runs: an `ephemeral` block (here `ephemeral "random_password"`)
is opened at the start of an operation and closed at the end, with nothing written to state or plan files. The challenge is keeping that promise as values travel.
Terraform checks it statically: an ephemeral value may flow only into other ephemeral contexts.

A child module output is a normal persisted value unless you say otherwise. Marking it `ephemeral = true` tells Terraform that the module returns a value which must not be stored, and
the caller then inherits the same restriction: it may use the value in provisioners, provider configuration, other ephemeral resources, ephemeral variables and write-only arguments, but not in
ordinary resource arguments or regular outputs. Root modules cannot expose ephemeral outputs at all — there is no one to hand the value to.

Compare with the previous ephemeral mission: a variable *enters* the configuration as ephemeral; here the value is *produced* inside a module. In both cases the outcome you verify is the same — grep the
state for the secret and find nothing. Remember the limit: the provisioner still delivered the token to a file, so protect the dispatch box. Ephemerality removes Terraform's own copies, not the ones you create.
