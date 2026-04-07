variable "filename" {
  type = string
  validation {
    condition     = length(var.filename) > 0
    error_message = "Filename must not be empty."
  }
}

resource "local_file" "config" {
  content  = "data"
  filename = "${path.module}/${var.filename}"
}
