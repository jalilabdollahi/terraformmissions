# Sample labels for the Kelpwater marine lab's dive survey.
# Every label file carries the id of the survey run that produced it.

resource "random_id" "run" {
  byte_length = 3
}

resource "local_file" "label" {
  for_each = toset(var.samples)
  filename = "${path.module}/labels/${each.key}-${random_id.run.hex}.txt"
  content  = "Sample label ${each.key}-${random_id.run.hex}\n"
}

output "run_id" {
  value = random_id.run.hex
}
