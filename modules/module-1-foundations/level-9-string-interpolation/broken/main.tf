variable "environment" {
  type    = string
  default = "production"
}

resource "local_file" "env_file" {
  content  = "ENV=$(environment)"    # Wrong: $() is shell syntax
  filename = "${path.module}/env.txt"
}
