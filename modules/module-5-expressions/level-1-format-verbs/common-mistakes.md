# Common mistakes

- **Wrapping the distance in `floor()` or `ceil()` to satisfy `%d`.** The plan passes, but the card now
  says 21 km and the zero-padded `021.1` is lost.
- **Using `%s` for the distance.** It renders `21.1`, with no padding, so the width-5 requirement fails.
- **Hard-coding the final line in `locals`.** It matches Ines, but any other rider prints her card.
- **Fixing the tag with `"TAG-0${...}"` string glue.** Works for tag 7, breaks for 1234.
- **Dropping `%q` for `\"%s\"`.** A name with a quote inside is no longer escaped.
