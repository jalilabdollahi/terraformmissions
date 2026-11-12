# Debrief — text is not bytes

Terraform strings are Unicode text. `data "local_file"` therefore offers two views of a file:
`content` (the file interpreted as text) and `content_base64` (the exact bytes, encoded so they fit
safely in a string). For a README or a JSON file the two are equivalent. For an image, a zip, a
compiled binary or a keystore they are not: bytes that are not valid UTF-8 cannot live in a
Terraform string, and the round trip through state quietly changes them.

The nasty part of this bug is how well it hides. The first apply even wrote an identical file,
because the raw bytes were still in memory. The trouble only showed on the next plan, when the
resource's recorded `content` no longer matched what the data source produced, and Terraform
proposed a replacement forever. A config that cannot reach a clean plan is a red flag in any
pipeline: it makes real drift impossible to spot.

The rule of thumb is simple. Whenever the thing you are moving is not human-readable text, use
`content_base64` on the reading side and `content_base64` on the writing side (`filebase64()` is the
equivalent function when you are not using a data source). The same pair exists on
`local_sensitive_file`, and the base64 form is what providers expect for things like TLS bundles,
uploaded objects and cloud-init payloads.

Verify binary copies with a checksum (`cmp`, `shasum`) and not by opening the file in an editor; an
editor will happily show you something that looks fine.
