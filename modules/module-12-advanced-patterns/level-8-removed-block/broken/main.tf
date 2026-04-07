# Bug: local_file.old is both declared as a resource AND listed in a removed block.
# Terraform 1.7+ requires the resource to be absent from config when using 'removed'.

resource "local_file" "old" {
  content  = "legacy content"
  filename = "${path.module}/old.txt"
}

removed {
  from = local_file.old

  lifecycle {
    destroy = false
  }
}
