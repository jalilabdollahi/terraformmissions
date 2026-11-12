# Common mistakes

- **Deleting the precondition.** The default booking applies, but nothing stops the nine-passenger sunrise flight.
- **Raising both limits to 12.** Standard bookings pass; the sunrise basket is overloaded.
- **Changing the caller's default to 8 passengers.** The caller was right; the rule was inverted, and other bookings still fail.
- **Changing the error message only.** The message is a description; the logic is in `condition`.
