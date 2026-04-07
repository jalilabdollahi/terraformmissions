terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "msg" {
  content  = "provider alias test"
  filename = "${path.module}/msg.txt"
}
