# Solution guide

1. `terraform apply` fails on the provisioner. The first error is about the working directory:
   `chdir ... dist: no such file or directory`; `dist/` does not exist yet, and nothing creates it before
   the command runs.
2. Fix `working_dir`: the command itself starts with `mkdir -p dist` and writes to `dist/RELEASE`, so
   it expects to start in the module root: `working_dir = path.module`.
3. Apply again. The next failure is that `bash` tries to run the command text as a script file
   (`No such file or directory`). `interpreter = ["bash"]` lacks the `-c` that tells bash "the next
   argument is the command". Use `interpreter = ["bash", "-c"]`.
4. The resource was marked tainted by the failed attempt; the next apply replaces it and runs the
   provisioner. `cat dist/RELEASE` shows `release=2024.3-rc1`.
