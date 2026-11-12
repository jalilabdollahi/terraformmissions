# Perfumery: bottle label sheets are zipped into one bundle for the distributor.

data "archive_file" "bundle" {
  type        = "zip"
  source_dir  = "${path.module}/labels"
  output_path = "${path.module}/dist/atelier.zip"
  excludes    = ["label-draft.tmp"]
}

resource "local_file" "receipt" {
  filename = "${path.module}/dist/receipt.txt"
  content  = <<-EOT
    Bundle: ${data.archive_file.bundle.output_path}
    Size: ${data.archive_file.bundle.output_size} bytes
    SHA-256: ${data.archive_file.bundle.output_sha256}
  EOT
}

output "bundle_sha256" {
  value = data.archive_file.bundle.output_sha256
}

output "bundle_size" {
  value = data.archive_file.bundle.output_size
}
