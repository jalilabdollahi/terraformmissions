# Common mistakes

- **Running `terraform apply -target=module.chiller` first.** It works once, but a new checkout, a CI run or a thickness
  change still hits the same problem.
- **Creating `rink/ice-log.txt` by hand.** The plan goes green, yet the schedule is always one apply behind; the
  validator starts from a rink without the file and changes the thickness.
- **Adding `depends_on` to the chiller instead.** The edge points the wrong way: the chiller would wait for the resurfacer.
- **Reading the value from the chiller's output.** That is a fine design, but the mission keeps the file-based
  contract between the two modules; the fix is the explicit dependency.
