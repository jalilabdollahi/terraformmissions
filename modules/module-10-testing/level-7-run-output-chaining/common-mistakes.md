# Common mistakes

- **Hard-coding 12 in `order_cloth`.** The run passes but the chain is gone; the validator requires the `run.measure_main.sail_area` reference.
- **Adding a `depends_on` to a run block.** Run blocks have no such argument; ordering is purely by position in the file.
- **Renaming the output in `sailloft.tf` to `area`.** That changes the module's interface to satisfy a typo in the test, and the mutants of the code are no longer caught as expected.
- **Moving only `spare_jib`.** The cycle is between `order_cloth` and `measure_main`; `spare_jib` is fine where it is.
