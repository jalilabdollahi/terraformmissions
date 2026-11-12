# Walkthrough - Climbing Wall Route Card

1. `terraform test` fails `classic_route` with `route card is wrong` and an object diff. All that is known: at
   least one of four facts is off.
2. Split every compound condition:
   ```hcl
   assert {
     condition     = output.route.grade == "6a"
     error_message = "the classic route is graded 6a"
   }
   assert {
     condition     = output.route.colour == "green"
     error_message = "grade 6a holds are green"
   }
   ```
   ...and likewise for `bolts` and `top_rope_ok`, and for the three facts in `tall_route`. Give each a message of its own.
3. Re-run: three of four asserts pass; the failing one reads `a 17 m route needs 9 bolts` with `8` vs `9` in the diff.
4. The test is right, the code is wrong: `floor(var.height_m / 2)` loses the last half pair. Change it to
   `ceil(var.height_m / 2)` in `routes.tf`.
5. `Success! 2 passed, 0 failed.`
