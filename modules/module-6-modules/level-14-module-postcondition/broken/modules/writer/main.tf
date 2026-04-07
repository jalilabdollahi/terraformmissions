variable "label" {
  type    = string
  default = "hello"
}

resource "local_file" "result" {
  content  = var.label
  filename = "${path.module}/result.txt"
}

output "content" {
  value = local_file.result.content
  # Wrong postcondition logic: value == "" means this passes only when empty
  postcondition {
    condition     = self.value == ""
    error_message = "content output must not be empty."
  }
}
