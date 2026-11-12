variable "series_no" {
  description = "Series number of the coin issue."
  type        = string
  default     = "CN-204"
}

resource "local_file" "strike_sheet" {
  provider = local.press
  filename = "${path.module}/press/${var.series_no}.txt"
  content  = "Strike sheet for ${var.series_no}\n"
}

resource "local_file" "die_log" {
  provider        = local.vault
  filename        = "${path.module}/vault/${var.series_no}-die.log"
  content         = "Master die logged for ${var.series_no}\n"
  file_permission = "0400"
}
