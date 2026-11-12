variable "notes_file" {
  type        = string
  description = "JSON file written by the lock keeper"
}

data "local_file" "notes" {
  filename = var.notes_file
}

locals {
  parsed = jsondecode(data.local_file.notes.content)
}
