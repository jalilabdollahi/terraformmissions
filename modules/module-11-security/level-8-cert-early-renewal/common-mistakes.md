# Common mistakes

- **Raising only `early_renewal_hours`.** With 6 hours of validity, a 168-hour window means the cert is renewed on every single plan.
- **Setting a huge validity (e.g. 87600 hours) and leaving the window at 0.** The cert lasts forever in practice but no longer rotates, which defeats the point of the exercise.
- **Editing `pki/pump.pem` by hand.** The next apply restores the file from state. The certificate has to come from the resource.
- **Running `terraform taint` and leaving the arguments unchanged.** You get a new 6-hour certificate, which the validator rejects.
