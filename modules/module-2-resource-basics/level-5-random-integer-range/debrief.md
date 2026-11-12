# Debrief: swapped bounds, caught at create time

`random_integer` has two mandatory arguments, `min` and `max`, and both bounds are inclusive. The
provider validates that `min <= max` while planning, so the mistake shows up before anything is
created. That is the best kind of failure: no half-applied state, a message that names the resource,
and one line to fix.

The bug itself is a classic. Both locals have sensible names and values; they were simply plugged
into the wrong slots. Naming the arguments from the same vocabulary (`first_card`/`min`,
`last_card`/`max`) makes it easier to read at a glance. If the range came from variables you could
also add a `validation` block so a swapped pair fails with your own message.

Like all random resources, the integer is generated once and then stored. The winner does not change
on the next plan, which is what you want for a jackpot draw; to redraw you would change a `keepers` value
or use `terraform apply -replace=random_integer.winning_card`. Note that this is pseudo-random
state, not a secure lottery: anyone with state access can read the result in advance.
