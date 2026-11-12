# Debrief: provisioners are shell commands in disguise

`local-exec` runs a command on the machine that runs Terraform. Terraform appends the `command`
string to the `interpreter` list and executes it, so what you pass must make sense as a program
plus its arguments. The default interpreter is `["/bin/sh", "-c"]` on Unix; if you override it to use
bash, you have to keep the `-c`. Without it bash looks for a script file named like your whole command.

`working_dir` is where the command starts, and it must already exist. Provisioners also run only
when their resource is created (or destroyed with `when = destroy`). When one fails, Terraform marks
the resource **tainted** so that the next apply recreates it and tries again. That is why a failing
provisioner is annoying: the resource exists in state but is considered half-built.

Pass values through `environment` instead of splicing them into the command text. It avoids quoting
bugs (an apostrophe in a variable is harmless this way) and keeps the shell command constant.

Real-world takeaway: provisioners are a last resort. They are not idempotent and Terraform cannot
see what they change. Prefer native resources, and when a provisioner is unavoidable keep the command
tiny, make it idempotent (`mkdir -p`) and write evidence (a marker file) that something else can verify.
