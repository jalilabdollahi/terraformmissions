# Cobbleton cutlery works: furnace bookkeeping.
#
# Terraform walks the dependency graph and runs independent nodes AT THE SAME TIME
# (default: 10 at once). Two nodes with no edge between them may run in either order,
# or together. Anything that only works in one order is a bug that concurrency exposes.

# The furnace needs a moment to settle before the ledger can be written.
resource "time_sleep" "furnace_settle" {
  create_duration = "1s"
}

# The alloy ledger records the melt. Its content depends on the furnace, so it is
# created after the settle delay.
resource "local_file" "alloy_ledger" {
  filename = "${path.module}/works/alloy-ledger.txt"
  content  = "Melt logged at ${time_sleep.furnace_settle.id}: 74% iron, 18% chromium, 8% nickel\n"
}

# The stamping slip is copied from the ledger by a shell command.
resource "terraform_data" "stamping_slip" {
  depends_on = [local_file.alloy_ledger]

  provisioner "local-exec" {
    command = "cat ${local_file.alloy_ledger.filename} > ${path.module}/works/stamping-slip.txt"
  }
}

output "slip_path" {
  value = "${path.module}/works/stamping-slip.txt"
}
