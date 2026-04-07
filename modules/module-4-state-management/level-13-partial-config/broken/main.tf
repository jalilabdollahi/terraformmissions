variable "state_path" {
  type    = string
  default = "terraform.tfstate"
}

resource "local_file" "config" {
  content  = "partial config demo"
  filename = "${path.module}/config.txt"
}
