# Cartographers' guild - published atlas index.

data "external" "archive" {
  program = ["python3", "${path.module}/scripts/list_sheets.py"]
}

# Stamped once, when the index is first created, and then kept.
resource "time_static" "published" {}

locals {
  sheets = sort(split(",", data.external.archive.result.names))
}

resource "local_file" "atlas_index" {
  filename = "${path.module}/atlas/index.md"
  content  = <<-EOT
    # Guild atlas index
    Generated: ${time_static.published.rfc3339}
    ${join("\n", [for s in local.sheets : "- ${s}"])}
  EOT
}

output "sheet_count" {
  value = length(local.sheets)
}
