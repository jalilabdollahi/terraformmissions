# Lumen Press encyclopedia - published volume index.

data "external" "archive" {
  program = ["python3", "${path.module}/scripts/list_entries.py"]
}

locals {
  entries = split(",", data.external.archive.result.names)
}

resource "local_file" "volume_index" {
  filename = "${path.module}/volume/index.md"
  content  = <<-EOT
    # Lumen Press volume index
    Generated: ${timestamp()}
    ${join("\n", [for s in local.entries : "- ${s}"])}
  EOT
}

output "entry_count" {
  value = length(local.entries)
}
