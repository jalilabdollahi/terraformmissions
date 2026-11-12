# Debrief — how input gets into an external program

The `external` data source has two ways of talking to a program, and only one of them is its
documented input channel.

- **`query`** is a map of strings. Terraform serialises it as a single JSON object and writes it to
  the program's **standard input**. The program reads, decodes and answers on stdout.
- **`program`** is the command line itself: the executable followed by fixed arguments. Anything you
  put there arrives in `$1`, `$2` ... and is a perfectly good way to pass constants such as a config
  path, but a script written for the stdin protocol will never look at them.

The mismatch in this mission is realistic: whoever wrote the script and whoever wrote the Terraform
had different mental models of the interface, and nothing in HCL can verify it. The failure was loud
only because the script validates its input. A script that quietly defaulted a missing weight to
zero would have produced plausible, wrong numbers.

Good external scripts are defensive in exactly this way: they check required keys, print a clear
message on stderr and exit non-zero, which Terraform surfaces as the error. On the Terraform side,
remember that `query` only accepts strings (numbers and bools are converted), and that the program
runs again on every plan, so changing a variable changes the query and therefore the result. That is
what the validator checked by feeding different variable values and comparing the answers.
