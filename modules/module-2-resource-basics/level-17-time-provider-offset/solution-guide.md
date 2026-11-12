# Solution guide

1. `terraform validate` reports:
   - `Unsupported attribute`: `time_offset.expiry` has no attribute `timestamp` (two references);
   - `terraform plan` additionally rejects `offset_days = "14d"`: a string that cannot be converted to a number.
2. `offset_days` is a number of days; the unit is part of the argument name (there are also `offset_hours`,
   `offset_minutes`, ...). Write `offset_days = 14`.
3. `time_offset` exports `rfc3339`, `rfc3339` fields `year`, `month`, `day`, `hour`, `minute`, `second`, `unix`.
   Use `time_offset.expiry.rfc3339`.
4. `terraform apply`; compare `terraform output coupon_issued coupon_expires` (14 days apart).
