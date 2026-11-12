# Elm Street Language School: weekly lesson bundle for the students' tablets.
# Each lesson is an object with a file name and some text.

data "archive_file" "bundle" {
  type        = "zip"
  output_path = "${path.module}/bundles/week.zip"

  dynamic "source" {
    for_each = var.lessons
    iterator = lesson
    content {
      filename = lesson.value.file
      content  = lesson.value.text
    }
  }
}

output "bundle_md5" {
  value = data.archive_file.bundle.output_md5
}
