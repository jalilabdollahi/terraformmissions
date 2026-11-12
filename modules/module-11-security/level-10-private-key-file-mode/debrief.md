# Debrief — a secret file needs the right resource and the right mode

OpenSSH, like most credential tools, refuses to use a private key that other users can read. That is a safety net, not a fix: a key that was
once world-readable on a shared build host should be treated as exposed. The best approach is to create it with the correct mode in the first place.

The `local` provider offers two resources for writing files. `local_file` is for ordinary content. `local_sensitive_file` has the same
arguments but treats `content` as sensitive, so Terraform never prints it in a plan diff, and its default mode is restrictive (0700) rather than permissive.
For private material, always pick it and set the mode explicitly. The `directory_permission` argument covers the folder the provider creates, so the
key does not sit inside a world-listable directory.

Remember two limits. A mode only protects the file on this machine: the content is also in state (`private_key_openssh` is stored in the
state file), so the state backend needs encryption and access control. And the public half is *supposed* to be readable, so leave it alone — over-restricting
public files breaks the tools that need them.
