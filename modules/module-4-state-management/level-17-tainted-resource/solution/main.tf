resource "null_resource" "task" {
  triggers = {
    run_id = "abc123"
  }

  provisioner "local-exec" {
    command = "echo Running task"
  }
}
