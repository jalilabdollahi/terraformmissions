# Coupon campaign for Marigold Sweets' spring newsletter.
# The issue time is frozen once (time_static) so the coupon code doesn't move
# every day, and the expiry is two weeks after that fixed moment.

resource "time_static" "issued" {}

resource "time_offset" "expiry" {
  base_rfc3339 = time_static.issued.rfc3339
  offset_days  = 14
}

resource "local_file" "coupon" {
  filename = "${path.module}/newsletter/coupon.txt"
  content  = <<-EOT
    MARIGOLD SPRING SAVER - 15% off
    Valid from: ${time_static.issued.rfc3339}
    Valid until: ${time_offset.expiry.rfc3339}
  EOT
}

output "coupon_expires" {
  value = time_offset.expiry.rfc3339
}

output "coupon_issued" {
  value = time_static.issued.rfc3339
}
