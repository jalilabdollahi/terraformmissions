# Debrief: a name convention is three arguments

`random_pet` builds `id` as `<prefix><separator><word><separator><word>...`. Three arguments control
the shape:

- `length` is the number of random words, not the total number of parts; the prefix is extra;
- `separator` is placed between every part including after the prefix, default `-`;
- `prefix` is copied verbatim, so capital letters and spaces end up in the name.

That last point is the trap: Terraform does not normalise anything, so `"Scope "` with a trailing
space produces `Scope _word_word`. If a prefix comes from a variable, add a `validation` block with a
regex, or build a safe form with `lower()` and `replace()`.

Why are random pets useful at all? They make disposable resources memorable (`scope-calm-otter` is
easier to say than a UUID) and they are stable once created. Do not use them for secrets: the word
list is small, so the names are guessable. For naming conventions in cloud providers, define the
convention once in a local or module so that two resources cannot disagree about it, the way these
two did.
