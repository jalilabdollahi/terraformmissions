resource "local_file" "lane" {
  count    = var.lane_count
  filename = "${path.root}/out/${var.site}-lane-${count.index + 1}.txt"
  content  = "${var.site}: lane ${count.index + 1} of ${var.lane_count} is oiled and ready\n"
}
