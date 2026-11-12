variable "thickness_mm" {
  type = number
}

resource "local_file" "ice_log" {
  filename = "${path.root}/rink/ice-log.txt"
  content  = "sheet=north\nthickness=${var.thickness_mm}\n"
}
