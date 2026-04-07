# BUG: timeout values must be duration strings like "10m", not plain numbers.

resource "null_resource" "slow_task" {
  timeouts {
    create = 600
  }
}
