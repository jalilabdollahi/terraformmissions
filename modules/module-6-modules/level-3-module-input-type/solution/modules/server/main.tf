variable "port" {
  type        = number
  description = "Port number"
}

resource "local_file" "port_file" {
  content  = "port=${var.port}"
  filename = "${path.module}/port.txt"
}
