# Strikeforce Lanes bowling alley: one score sheet per lane.
# Lane 7 is being permanently closed. Its resource block is gone, and a removed block
# was added to say what to do about the object. Closing a lane also means leaving a
# retirement receipt for the insurance auditor, written when the sheet is destroyed.

resource "local_file" "lane_5" {
  filename = "${path.module}/lanes/lane-5.txt"
  content  = "lane 5: open\n"
}

resource "local_file" "lane_6" {
  filename = "${path.module}/lanes/lane-6.txt"
  content  = "lane 6: open\n"
}

removed {
  from = local_file.lane_7

  lifecycle {
    destroy = false
  }

  provisioner "local-exec" {
    when    = destroy
    command = "mkdir -p receipts && echo 'retired ${self.filename}' > receipts/lane-7.txt"
  }
}
