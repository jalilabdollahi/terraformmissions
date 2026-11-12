# Hartley Heath Trebuchet Society launches.
# The launch ledger is a placeholder resource whose ID is printed on every shot card.
# The team is retiring the null provider: the ledger was switched to the built-in
# terraform_data resource, which is where the plan now fails.

resource "terraform_data" "launch_ledger" {
  triggers_replace = {
    field   = "Hartley Heath"
    engine  = "TB-7"
  }
}

resource "local_file" "shot_card" {
  filename = "${path.module}/shots/tb-7.txt"
  content  = "shot card for TB-7 from Hartley Heath, ledger ${terraform_data.launch_ledger.id}\n"
}

moved {
  from = null_resource.launch_ledger
  to   = terraform_data.launch_ledger
}
