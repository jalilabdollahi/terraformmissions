# The resource block for local_file.old has been removed from config.
# The 'removed' block instructs Terraform to remove it from state without destroying the file.

removed {
  from = local_file.old

  lifecycle {
    destroy = false
  }
}
