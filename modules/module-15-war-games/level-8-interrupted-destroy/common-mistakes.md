# Common mistakes

- **Adding `on_failure = continue` to the destroy provisioner.** The destroy goes green, but nothing hands the rigs
  back; `crates/unrig.log` stays without m2 and m3 and the landowner invoices for them.
- **Deleting the lock without checking the pid.** Here it is stale, but removing a live lock lets two unrig
  processes corrupt the crate manifest.
- **Removing the module block from main.tf.** Destroy-time provisioners of a module that is no longer in
  configuration cannot run: the objects vanish from state without their handover.
- **`terraform destroy` for a fast finish.** It also destroys the client register, whose serial is on next year's
  contracts.
- **Forgetting `tags/m3.txt`.** The plan is clean because Terraform no longer knows the file; the orphan is
  printed at the entrance next week.
