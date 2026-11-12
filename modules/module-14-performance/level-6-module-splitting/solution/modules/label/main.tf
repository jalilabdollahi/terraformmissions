resource "local_file" "label" {
  filename = "${path.root}/out/label.txt"
  content  = "Batch ${var.batch_code} | wick ${var.wick_cm} cm | scent: ${var.scent}\n"
}

output "label_text" {
  value = local_file.label.content
}
