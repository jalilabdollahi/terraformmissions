# Wedding invitation letter, stitched from two reusable text snippets
# that live in the templates/ folder next to this file.
variable "guest" {
  type    = string
  default = "Aunt Bettina"
}

locals {
  header = file("header.txt")
  footer = file("footer.txt")
}

resource "local_file" "invitation" {
  filename = "${path.module}/letters/invitation.txt"
  content  = "Dear ${var.guest},\n\n${local.header}\n${local.footer}"
}

output "letter_bytes" {
  value = length(local_file.invitation.content)
}
