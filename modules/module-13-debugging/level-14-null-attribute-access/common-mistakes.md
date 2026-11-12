# Common mistakes

- **Giving every item a claim with a blank holder.** That changes the data instead of handling absence.
- **Hard-coding the four expected lines.** The validator plans with different items and the sheet would be wrong.
- **Fixing only `holder`.** The next error is the null phone in the interpolation; each nullable path needs a guard.
- **Wrapping the whole line in one `try()`.** A failure anywhere would silently produce the fallback text for the entire line, hiding real mistakes.
- **Using `coalesce(item.claim.phone, "n/a")` without a `try`.** If `claim` itself is null, reading `.phone` still raises.
