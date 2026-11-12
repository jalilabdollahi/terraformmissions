resource "local_file" "label" {
  filename = "${path.root}/out/label.txt"
  content  = "Batch ${var.batch_code} | pigment ${var.pigment_pct}% | shade: ${var.shade}\n"
}

output "label_text" {
  value = local_file.label.content
}
