variable "environment" {
  type    = string
  default = "production"
}

resource "local_file" "env_file" {
  content  = "ENV=${var.environment}"
  filename = "${path.module}/env.txt"
}
