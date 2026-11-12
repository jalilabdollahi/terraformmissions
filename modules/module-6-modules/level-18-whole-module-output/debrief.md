# Debrief — a module is an object you can pass around

Referring to `module.stall` without an attribute gives you the *whole* object: one attribute for every output the module
declares. That makes it an ordinary Terraform value with an object type, so everything that works on objects works on it:
`keys()` lists the output names, `values()` the values, `jsonencode()` serialises it, `merge()` combines two modules'
outputs, `for` expressions iterate over it, and you can pass it as an input to another module whose variable is typed
`object({...})` or `any`.

The errors in this level come from forgetting that an object is not a string and not a list. Arguments have strict types:
`content` needs a string, `sort` needs a list. Terraform's automatic conversions go from tuples to lists and numbers to
strings, never from an object to either. You have to choose the conversion explicitly.

There is a robustness bonus. Because the board is built from the whole object, adding an output to the module later puts it
on the board with no change in the root. The same idea powers "export everything" patterns, such as dumping a module's
outputs to a JSON file for another tool to read.

One limit to remember: if any of the module's outputs is sensitive, the whole object becomes sensitive when you hand
it to `jsonencode`, and a file resource will refuse to display it. Use `local_sensitive_file` or pick specific outputs then.

**Takeaway:** `module.x` is an object of all outputs; convert it deliberately with `jsonencode`, `keys` or `for` and
never copy its fields by hand.
