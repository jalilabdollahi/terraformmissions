# Common mistakes

- **Wrapping the index in `tonumber()` or the scent in `tostring()`.** The values are the wrong ones,
  not the wrong type; it still labels jars "01-0" or errors.
- **Using `count.index`.** It exists only inside resource blocks with `count`; it is not valid in a
  for expression.
- **Starting the numbering at `position` instead of `position + 1`.** The labels begin at 00.
- **Declaring a new `wax` name in the second expression but forgetting to change the body.** The
  names after `for` and in the body have to match.
- **Hard-coding the labels as a literal list.** The check supplies two different scents.
