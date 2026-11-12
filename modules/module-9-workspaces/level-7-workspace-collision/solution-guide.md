# Solution guide

**Diagnose.** `ls out/` shows only `bunks.txt` and `wake-calls.txt`. In the east workspace
`terraform plan` says the content of both files will change from "Wing west" to "Wing east" (or the
reverse after the next apply). Two workspaces, one path.

**Fix.** Make the paths unique per workspace:

```hcl
filename = "${path.module}/out/${terraform.workspace}-bunks.txt"
filename = "${path.module}/out/${terraform.workspace}-wake-calls.txt"
```

A subdirectory per workspace would work equally well. Apply in each wing: both get their own pair of files.
