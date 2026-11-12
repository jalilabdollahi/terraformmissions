# Common mistakes

- **Changing `== 9` to `== 8`.** The suite turns green, but the validator applies the config and checks the real card says 9 bolts.
- **Splitting but reusing one generic message everywhere.** The messages must differ and describe their own fact; "route card is wrong" on every assert is the same problem.
- **Keeping one `&&` "to save lines".** Any condition with `&&` is rejected.
- **Fixing the code to `ceil` but leaving the compound assert.** The suite passes, but the diagnosis lesson is lost and the validator rejects the leftover `&&`.
