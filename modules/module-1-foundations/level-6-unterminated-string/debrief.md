# Debrief — Marlowe Museum Placards

**What broke.** A quoted string in HCL starts at `"` and must end at the next unescaped `"` on the
same line. The `content` of the gallery-4 placard never closed. The parser kept reading: it hit
the end of the line, complained about a multi-line string, and then, because it could not tell
where the string really ended, misread the lines after it.

**Cascading errors.** When a parser loses track of quote pairs, everything after the first
mistake is interpreted wrongly. That is why you may see several errors that look unrelated. The
rule is: fix the *first* error, then re-run. Ninety percent of the time the rest vanish.

**Escapes and alternatives.** To get a newline inside a quoted string, write `\n`. For truly multi-line
text, use a heredoc (`<<EOT ... EOT`), which does not need closing quotes at all. To put a literal quote
inside a string, escape it as `\"`; forgetting that has the same effect as a missing quote.

**Real-world takeaway.** Syntax highlighting is your best friend here: an unclosed string turns the
rest of the file the colour of a string. If your editor suddenly paints half the file one colour,
look for a missing quote above that point. And always read error lists from the top.
