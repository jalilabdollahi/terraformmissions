# Post-mortem — Cedarbank Kiln Pipeline

**Timeline.** 23:10 the nightly pipeline started; 23:12 the ash handshake was rejected with exit code 3 and the
apply stopped; 23:13 the runner was OOM-killed before it flushed state for two objects; 23:40 on-call tainted
`kiln_run["pine"]` "to be safe"; 00:30 the incident lead sorted the state by evidence.

**Root causes.**
1. A one-character typo (`K4`) in a lot definition passed review because nothing validates kiln names before
   the handshake runs at apply time.
2. A failed `local-exec` provisioner marks the resource tainted automatically, which is right: the work was not
   completed, so it must run again.
3. The runner died between creating objects and writing state, leaving real things (printed tags) that
   Terraform does not know about.
4. A manual taint was applied to a healthy resource. Taint is a request to destroy and recreate it.

**Lessons.** Tainted does not mean broken; it means "will be replaced". Decide per object from evidence in the
ledger. Where Terraform lost track of an identifier that exists in the real world, import it rather than
letting a plan invent a replacement. Terraform's importer for generated values accepts exactly the data on the
paper trail.

**Prevention.**
- Validate lot inputs against the allow-list with a `validation` block or `precondition`.
- Write state to a durable remote backend so a killed runner cannot lose a write.
- Use `terraform plan -replace=ADDR` for deliberate replacement; reserve `taint` for provider-flagged damage.
- Keep the provisioner ledger: it is what let on-call prove the pine handshake had succeeded.
