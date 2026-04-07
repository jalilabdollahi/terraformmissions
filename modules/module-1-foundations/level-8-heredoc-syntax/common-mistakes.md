# Common Mistakes

- **Mixing `<<EOF` with an indented closing marker** — use `<<-EOF` instead.
- **Trailing spaces after the closing marker** — `EOF  ` (with spaces) is not recognised as the marker.
- **Wrong marker name** — the opening and closing names must match exactly: `<<-MYMARKER` ... `MYMARKER`.