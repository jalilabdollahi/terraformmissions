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
  postcondition {
    condition     = self.value != ""
    error_message = "content output must not be empty."
  }
}
