# Common mistakes

- **Quoting the value: `floodlights = "true"`.** It happens to convert, but the declared type is still
  `string` and the variable carries a string around the code. The mission asks for a real bool.
- **Writing `var.floodlights == "on" ? 1 : 0`.** It plans, but the validator forbids comparing and a
  caller passing `true` would now be a type error.
- **Changing the count to `count = 1`.** The schedule is created even when the lights are off.
- **Deleting the count and the ternary in the notice.** The resource would exist on dark nights too.
