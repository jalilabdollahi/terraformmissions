# Debrief - one assert, one fact

A compound condition such as `a && b && c && d` has a single outcome and a single message, so when it fails you
learn that *something* is wrong, and have to rebuild the check by hand to find what. Terraform prints a diff of
the values it compared, but for an object output that is a wall of text, and for `&&` it reports only the whole
expression's result.

Splitting the chain into one assert per fact costs a few lines and pays back every time. The run
report now names the exact attribute (`a 17 m route needs 9 bolts`), Terraform evaluates and reports **every**
assert in the run, not just the first failure, so several defects show up in a single pass, and a future
reader can see from the test alone what the module promises.

Good messages state the expectation ("grade 6a holds are green"), not the failure ("colour wrong"): they read
as documentation when the test passes and as a diagnosis when it fails. Include the numbers that matter when
they are not secret.

This level also shows why you must not "fix" the first red result by editing the test to agree with the code.
The expectation (17 m needs 9 bolts, because bolts are placed every 2 m and the top anchor needs one) is the
specification; the rounding in the code was the defect. Split first, diagnose, then decide which side is wrong.

Real-world takeaway: one assertion per behaviour, messages written as expectations, and never trust a green
test whose condition you cannot read aloud as a sentence.
