# Common mistakes

- **Wrapping the whole map in `try(..., {})`.** All cubers vanish when one value is bad.
- **Editing `raw_times` to clean the data.** The judges' strings are the input; the second dataset
  in the check has the same kinds of mess.
- **Handling the comma but not the space.** `tonumber(" 11.9")` still fails; Noor is missing.
- **Filtering with `t != "DNF"`.** DSQ and every other word still crash the conversion.
- **Replacing every comma and dot.** Removing both turns 13,1 into 131.
