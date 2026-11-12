# Debrief — two directories, two meanings

Terraform gives you three path values. `path.cwd` is where you launched the command; `path.root` is the directory
of the root module; `path.module` is the directory of the module whose code is being evaluated. In the root
configuration, `path.module` and `path.root` are the same. Inside a child module they differ, and mixing them up
is the most common bug when somebody moves code into `modules/`.

The rule of thumb is about **ownership**. Files that belong to the module, such as templates, scripts and static data,
are found with `path.module`, so that the module keeps working wherever it is called from. Files the module
*produces* for the caller to use (generated configuration, artefacts, reports) usually belong in the caller's
workspace and use `path.root`, or better, take their folder as an input variable.

Be aware that in real projects writing outside the module is itself a design question. Many teams give the module a
`output_dir` variable that the root fills with `"${path.root}/audio"`, so the module never needs to guess. That keeps
the module free of hidden assumptions and makes tests easier.

Another trap: the value of `path.module` is *relative* (`modules/guide`) and is evaluated from the root directory. It
is stable between runs from the same working directory, but never rely on it containing an absolute path.

**Takeaway:** `path.module` for what the module ships, `path.root` for what it hands to the project, never `path.cwd`.
