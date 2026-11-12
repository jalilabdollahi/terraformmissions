# Debrief - the shape of a test file

A Terraform test file is HCL, but only a small vocabulary is legal at the top level: `run`, `variables`,
`provider`, `mock_provider`, `test` (settings only) and a few others. Everything that describes one
scenario lives in a `run "<name>"` block, and the name is what you see in the output and what you pass
to `terraform test -filter`.

The mistake here is a classic from people arriving from other ecosystems: `test "name" { ... }` looks
natural, and Terraform answers with "Extraneous label for test". The error is structural, so none of
your assertions were evaluated - a suite that cannot parse tells you nothing about the code.

Notice also what the exit code means. A test file that fails to parse makes `terraform test` exit
non-zero, but an *empty* tests directory exits 0 with "0 passed, 0 failed". Never treat "no failures"
as "tested": in CI, assert that the pass count is what you expect, or that named runs are reported.

Real-world takeaway: keep test files small and named after behaviour (`single_axle`, `discount_half`),
run `terraform test -verbose` while authoring, and make CI fail on a zero-test result so a typo in a
directory name or block type cannot silently turn your safety net off.
