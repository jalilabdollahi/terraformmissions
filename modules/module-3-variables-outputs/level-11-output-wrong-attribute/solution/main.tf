# Lumen Stock Photo Agency — catalogue export.
# The agency's partner portal pulls two values from Terraform outputs: where the
# catalogue file lives and its checksum, so it can verify the download.

variable "photos" {
  description = "Photo rows: code, subject, licences sold."
  type        = list(string)
  default = [
    "LS-001,misty pines,14",
    "LS-002,city rooftops,6",
    "LS-003,desert road,23",
  ]
}

resource "local_file" "catalogue" {
  filename = "${path.module}/archive/catalogue.csv"
  content  = "code,subject,licences\n${join("\n", var.photos)}\n"
}

output "catalogue_path" {
  description = "Where the partner portal fetches the catalogue."
  value       = local_file.catalogue.filename
}

output "catalogue_checksum" {
  description = "SHA-256 of the catalogue content."
  value       = local_file.catalogue.content_sha256
}

output "licence_total" {
  value = sum([for row in var.photos : tonumber(element(split(",", row), 2))])
}
