resource "local_file" "lane_5" {
  filename = "${path.module}/lanes/lane-5.txt"
  content  = "lane 5: open\n"
}

resource "local_file" "lane_6" {
  filename = "${path.module}/lanes/lane-6.txt"
  content  = "lane 6: open\n"
}

resource "local_file" "lane_7" {
  filename = "${path.module}/lanes/lane-7.txt"
  content  = "lane 7: open\n"
}
