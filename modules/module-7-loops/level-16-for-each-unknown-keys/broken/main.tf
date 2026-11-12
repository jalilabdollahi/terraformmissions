# Sample labels for the Kelpwater marine lab's dive survey.
# Every label file carries the id of the survey run that produced it.

resource "random_id" "run" {
  byte_length = 3
}

locals {
  label_keys = toset([for s in var.samples : "${s}-${random_id.run.hex}"])
}

resource "local_file" "label" {
  for_each = local.label_keys
  filename = "${path.module}/labels/${each.key}.txt"
  content  = "Sample label ${each.key}\n"
}

output "run_id" {
  value = random_id.run.hex
}
