# BUG: the resource is named "job" but the taint command targets "task".
# Rename the resource to "task" so taint can find it.

resource "null_resource" "job" {
  triggers = {
    run_id = "abc123"
  }

  provisioner "local-exec" {
    command = "echo Running job"
  }
}
