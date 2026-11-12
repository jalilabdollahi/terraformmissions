# Debrief - a condition is a claim, read it aloud

An `assert` passes when its `condition` is true, and `error_message` is only shown when it is false. That
makes the message the *only* statement of intent in the block, and nothing forces it to agree with the
condition. Negations and inverted comparisons are easy to write and
easy to read past, because the message you read says the right thing.

When a test fails, first decide who is wrong: the code or the test. Here the pacing sheet is correct (a
5:30/km runner does finish in 68 minutes), so the fix belongs in the test. Terraform helps by printing
the values it compared. In 1.17 you get an `LHS`/`RHS` or `Diff` section under the condition with the
actual numbers; read them before editing anything.

A subtle trap: a failing test is not a reason to loosen it. Changing `>=` to `>= 0` or deleting an assert
turns the suite green and removes the safety net. The right fix keeps the *intent* in the message and
rewrites the expression until it states exactly that.

Real-world takeaway: write conditions so they read like the message ("finish_minutes < cutoff"), avoid
double negatives, and when you flip a scenario (the slow runner), flip the expectation deliberately. A
reviewer should be able to read the message and the condition together and see the same sentence twice.
