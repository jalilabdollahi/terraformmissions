# Common mistakes

- **Running `terraform apply -target=local_file.batch_sheet` first.** It gets you past the missing
  file once, but the config is unchanged: change `base_grams` and the dose is stale again.
- **Creating `bench/batch-sheet.txt` by hand.** Same problem: it hides the missing dependency until
  the next clean checkout (or the next CI run) fails.
- **Replacing the data source with local values.** The mission is about reading the generated file;
  the validator expects the data source to stay.
- **Putting `depends_on` on the output or on `dose_label`.** The ordering problem is on the data
  source's side; dependencies on the consumers do not delay the read.
