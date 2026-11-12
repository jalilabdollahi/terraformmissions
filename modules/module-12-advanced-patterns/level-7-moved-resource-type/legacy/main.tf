resource "null_resource" "launch_ledger" {
  triggers = {
    field   = "Hartley Heath"
    engine  = "TB-7"
  }
}

resource "local_file" "shot_card" {
  filename = "${path.module}/shots/tb-7.txt"
  content  = "shot card for TB-7 from Hartley Heath, ledger ${null_resource.launch_ledger.id}\n"
}
