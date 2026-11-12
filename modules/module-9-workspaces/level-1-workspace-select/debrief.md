# Debrief: which workspace am I in?

A workspace is a named slot for state inside one backend. Every command you run (plan, apply, destroy,
`state list`) works on exactly one slot, the *selected* one. With the local backend the selection is
stored in `.terraform/environment`, and every non-default slot lives in
`terraform.tfstate.d/<name>/terraform.tfstate`. Here the trainee's apply landed in `default`, because
nothing in the config says which workspace is intended. The same code produced a perfectly valid but
misplaced result.

That is the first thing to know about workspaces: the CLI context is invisible state of its own. It
does not appear in the code or in a pull request, and it is easy to forget. Teams that rely on workspaces
usually protect themselves in three ways:

- print the workspace in the shell prompt, or run `terraform workspace show` at the start of every script;
- add a guard so unexpected workspaces fail fast (a later mission covers that);
- drive the workspace from CI rather than from a person's terminal.

Note how the file name carried `terraform.workspace`. That is why the two environments could coexist in
one directory. Remove it and both would fight over the same file.

**When workspaces are the wrong tool:** if staging and prod need different credentials, accounts, access
rules or review processes, a shared directory with a mutable "current workspace" is a risky arrangement.
Separate root modules (or separate directories/pipelines per environment) give each environment its own
backend and its own permissions, and make "wrong environment" mistakes much harder.
