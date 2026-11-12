# Common mistakes

- **Converting with `tostring()` in HCL.** `tostring(false)` is `"false"`, not `"no"`, and
  `tostring(2.1)` is `"2.1"`. The information is already lost.
- **Replacing `yamldecode(file(...))` with a hand-written local object.** The mission is about
  reading the file, and the check feeds the code a different file.
- **Quoting only the firmware.** Hartmann then reads `lang false`.
- **Fixing the YAML but not the attribute path.** Plan still fails on `instruments`.
- **Using `jsondecode()`.** The file is YAML; JSON parsing fails on the first line.
