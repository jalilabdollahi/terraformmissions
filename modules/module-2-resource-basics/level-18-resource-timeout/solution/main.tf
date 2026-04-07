resource "null_resource" "slow_task" {
  timeouts {
    create = "10m"
  }
}
