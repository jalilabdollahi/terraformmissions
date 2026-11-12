resource "null_resource" "launch_ledger" {
  triggers = {
    site    = "Kettleby Moor"
    balloon = "WB-7"
  }
}

resource "local_file" "flight_card" {
  filename = "${path.module}/flights/wb-7.txt"
  content  = "flight card for WB-7 from Kettleby Moor, ledger ${null_resource.launch_ledger.id}\n"
}
