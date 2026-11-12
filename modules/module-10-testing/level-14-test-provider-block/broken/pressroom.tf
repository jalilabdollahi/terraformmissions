variable "catalog_no" {
  description = "Catalogue number of the release."
  type        = string
  default     = "TX-204"
}

resource "local_file" "sleeve_note" {
  provider = local.press
  filename = "${path.module}/press/${var.catalog_no}.txt"
  content  = "Sleeve note for ${var.catalog_no}\n"
}

resource "local_file" "master_log" {
  provider        = local.vault
  filename        = "${path.module}/vault/${var.catalog_no}-master.log"
  content         = "Master tape logged for ${var.catalog_no}\n"
  file_permission = "0400"
}
