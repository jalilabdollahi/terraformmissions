# Added for the autumn flash event (copied from the swallow sheet above).
resource "local_file" "flash_sheet" {
  filename = "${path.module}/flash/anchor.txt"
  content  = "ANCHOR\nSaturday 12:30 - ${var.venue}\nDeposit due at booking.\n"
}
