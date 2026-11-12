# Cobbleton Sugar-Glass Stage-Prop Workshop: stove bookkeeping.
#
# Terraform walks the dependency graph and runs independent nodes AT THE SAME TIME
# (default: 10 at once). Two nodes with no edge between them may run in either order,
# or together. Anything that only works in one order is a bug that concurrency exposes.

# The stove needs a moment to settle before the ledger can be written.
resource "time_sleep" "stove_settle" {
  create_duration = "1s"
}

# The syrup ledger records the boil. Its content depends on the stove, so it is
# created after the settle delay.
resource "local_file" "syrup_ledger" {
  filename = "${path.module}/workshop/syrup-ledger.txt"
  content  = "Melt logged at ${time_sleep.stove_settle.id}: 70% sugar, 20% glucose, 10% water\n"
}

# The label slip is copied from the ledger by a shell command.
resource "terraform_data" "label_slip" {
  provisioner "local-exec" {
    command = "cat ${path.module}/workshop/syrup-ledger.txt > ${path.module}/workshop/label-slip.txt"
  }
}

output "slip_path" {
  value = "${path.module}/workshop/label-slip.txt"
}
