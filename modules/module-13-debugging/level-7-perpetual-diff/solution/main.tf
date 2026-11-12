# Lumen Press encyclopedia - published volume index.

data "external" "archive" {
  program = ["python3", "${path.module}/scripts/list_entries.py"]
}

# Stamped once, when the index is first created, and then kept.
resource "time_static" "published" {}

locals {
  entries = sort(split(",", data.external.archive.result.names))
}

resource "local_file" "volume_index" {
  filename = "${path.module}/volume/index.md"
  content  = <<-EOT
    # Lumen Press volume index
    Generated: ${time_static.published.rfc3339}
    ${join("\n", [for s in local.entries : "- ${s}"])}
  EOT
}

output "entry_count" {
  value = length(local.entries)
}
