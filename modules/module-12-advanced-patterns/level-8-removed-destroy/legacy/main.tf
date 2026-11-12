resource "local_file" "target_5" {
  filename = "${path.module}/targets/target-5.txt"
  content  = "target 5: open\n"
}

resource "local_file" "target_6" {
  filename = "${path.module}/targets/target-6.txt"
  content  = "target 6: open\n"
}

resource "local_file" "target_7" {
  filename = "${path.module}/targets/target-7.txt"
  content  = "target 7: open\n"
}
