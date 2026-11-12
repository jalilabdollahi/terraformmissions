# Cinder Valley Seed Vault — catalogue export.
# The vault's partner portal pulls two values from Terraform outputs: where the
# catalogue file lives and its checksum, so it can verify the download.

variable "accessions" {
  description = "Seed accession rows: code, species, jars on the shelf."
  type        = list(string)
  default = [
    "CV-001,sweet pea,14",
    "CV-002,blue lupin,6",
    "CV-003,wild fennel,23",
  ]
}

resource "local_file" "catalogue" {
  filename = "${path.module}/vault/catalogue.csv"
  content  = "code,species,jars\n${join("\n", var.accessions)}\n"
}

output "catalogue_path" {
  description = "Where the partner portal fetches the catalogue."
  value       = local_file.catalogue.filename
}

output "catalogue_checksum" {
  description = "SHA-256 of the catalogue content."
  value       = local_file.catalogue.content_sha256
}

output "jar_total" {
  value = sum([for row in var.accessions : tonumber(element(split(",", row), 2))])
}
