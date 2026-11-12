# Permission pack for Greystone School's trips.
# Every document in var.documents becomes one entry inside a single zip file.

resource "archive_file" "trip_pack" {
  type        = "zip"
  output_path = "${path.module}/dist/trip-pack.zip"

  dynamic "files" {
    for_each = var.documents
    content {
      filename = files.key
      content  = files.value
    }
  }
}

output "pack_path" {
  value = archive_file.trip_pack.output_path
}
