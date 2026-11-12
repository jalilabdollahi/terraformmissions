# Cartographers' guild - published atlas index.

data "external" "archive" {
  program = ["python3", "${path.module}/scripts/list_sheets.py"]
}

locals {
  sheets = split(",", data.external.archive.result.names)
}

resource "local_file" "atlas_index" {
  filename = "${path.module}/atlas/index.md"
  content  = <<-EOT
    # Guild atlas index
    Generated: ${timestamp()}
    ${join("\n", [for s in local.sheets : "- ${s}"])}
  EOT
}

output "sheet_count" {
  value = length(local.sheets)
}
