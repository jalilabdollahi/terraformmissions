# Karakul expedition: base camp provisioning checklist.

resource "null_resource" "oxygen_cache" {
  triggers = {
    cylinders = "24"
    refill    = "day-5"
  }
}

resource "null_resource" "radio_schedule" {
  triggers = {
    window = "06:00-06:30 UTC"
  }
}
