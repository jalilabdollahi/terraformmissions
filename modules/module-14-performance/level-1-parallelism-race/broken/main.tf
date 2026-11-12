# Brackenhill bell foundry: furnace bookkeeping.
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
  filename = "${path.module}/foundry/alloy-ledger.txt"
  content  = "Melt logged at ${time_sleep.furnace_settle.id}: 78% copper, 22% tin\n"
}

# The casting slip is copied from the ledger by a shell command.
resource "terraform_data" "casting_slip" {
  provisioner "local-exec" {
    command = "cat ${path.module}/foundry/alloy-ledger.txt > ${path.module}/foundry/casting-slip.txt"
  }
}

output "slip_path" {
  value = "${path.module}/foundry/casting-slip.txt"
}
