# Iron Crane Dojo: weekly class bundle for the students' tablets.
# Each class is an object with a file name and some text.

data "archive_file" "bundle" {
  type        = "zip"
  output_path = "${path.module}/bundles/week.zip"

  dynamic "source" {
    for_each = var.classes
    iterator = class
    content {
      filename = source.value.file
      content  = source.value.text
    }
  }
}

output "bundle_md5" {
  value = data.archive_file.bundle.output_md5
}
