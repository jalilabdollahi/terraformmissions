# Kettleby Moor weather balloon launches.
# The launch ledger is a placeholder resource whose ID is printed on every flight card.
# The team is retiring the null provider: the ledger was switched to the built-in
# terraform_data resource, which is where the plan now fails.

resource "terraform_data" "launch_ledger" {
  triggers_replace = {
    site    = "Kettleby Moor"
    balloon = "WB-7"
  }
}

resource "local_file" "flight_card" {
  filename = "${path.module}/flights/wb-7.txt"
  content  = "flight card for WB-7 from Kettleby Moor, ledger ${terraform_data.launch_ledger.id}\n"
}

moved {
  from = null_resource.launch_ledger
  to   = terraform_data.launch_ledger
}
