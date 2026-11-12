# Walkthrough — Stamp Sheet Label Receipt

1. **Diagnose.** `terraform plan` fails: `error archiving directory: could not archive missing
   directory: .../label`. The folder is called `labels` (plural).
2. **Fix `source_dir`**, then plan. It works, but `unzip -l dist/bureau.zip` (or
   `python3 -m zipfile -l dist/bureau.zip`) lists `label-draft.tmp`. Add
   `excludes = ["label-draft.tmp"]` to the data source.
3. **Fix the checksum.** `output_base64sha256` is base64, but `shasum -a 256 dist/bureau.zip` prints
   hex. The attribute that matches is `output_sha256`; use it in both the receipt and the output.
4. `terraform apply`, compare with `shasum -a 256`, type `check`.
