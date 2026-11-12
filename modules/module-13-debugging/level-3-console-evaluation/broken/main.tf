# Kestrel ground station - which satellite passes are worth booking antenna time for?

locals {
  passes_csv = <<-CSV
    satellite,minutes,elevation
    KESTREL-1,9,62
    KESTREL-2,45,28
    HERON-3,120,41
    HERON-4,15,77
    OSPREY-5,88,35
    OSPREY-6,7,33
    TERN-7,102,19
  CSV

  passes = csvdecode(local.passes_csv)

  # Only passes that climb above 30 degrees are usable.
  usable = [for p in local.passes : p if p.elevation > 30]

  # The three longest usable windows, longest first.
  ranked          = reverse(sort([for p in local.usable : p.minutes]))
  top_minutes     = slice(local.ranked, 0, 3)
  longest_windows = [for m in local.top_minutes : [for p in local.usable : p.satellite if p.minutes == m][0]]

  # Minutes per satellite family (the part of the name before the dash).
  per_family = { for p in local.usable : split("-", p.satellite)[0] => p.minutes }
}

resource "local_file" "booking_sheet" {
  filename = "${path.module}/downlink/booking.txt"
  content  = "${join("\n", local.longest_windows)}\n"
}

output "longest_windows" {
  value = local.longest_windows
}

output "total_usable_minutes" {
  value = sum([for p in local.usable : p.minutes])
}

output "per_family_minutes" {
  value = local.per_family
}
