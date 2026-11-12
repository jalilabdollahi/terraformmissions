terraform {
  required_providers {
    local = {
      source                = "hashicorp/local"
      configuration_aliases = [local.mirror]
    }
  }
}

variable "treatment" {
  type = string
}

resource "local_file" "primary" {
  filename = "${path.root}/ledger/primary.txt"
  content  = "${var.treatment}\n"
}

resource "local_file" "mirror" {
  provider = local.mirror

  filename = "${path.root}/ledger/mirror.txt"
  content  = "${var.treatment}\n"
}

output "files" {
  value = [local_file.primary.filename, local_file.mirror.filename]
}
