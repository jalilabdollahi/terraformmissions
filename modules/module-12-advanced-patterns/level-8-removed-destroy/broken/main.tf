# Fletcher's Meadow Archery Range: one scorecard per target.
# Target 7 is being permanently closed. Its resource block is gone, and a removed block
# was added to say what to do about the object. Closing a target also means leaving a
# retirement receipt for the range safety inspector, written when the scorecard is destroyed.

resource "local_file" "target_5" {
  filename = "${path.module}/targets/target-5.txt"
  content  = "target 5: open\n"
}

resource "local_file" "target_6" {
  filename = "${path.module}/targets/target-6.txt"
  content  = "target 6: open\n"
}

removed {
  from = local_file.target_7

  lifecycle {
    destroy = false
  }

  provisioner "local-exec" {
    when    = destroy
    command = "mkdir -p receipts && echo 'retired ${self.filename}' > receipts/target-7.txt"
  }
}
