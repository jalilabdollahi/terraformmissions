output "reading" {
  description = "The ranger's latest reading as an object: ranger, snow_cm, trail_open"
  value = {
    ranger     = local.parsed.ranger
    snow_cm   = local.parsed.snow_cm
    trail_open = local.parsed.trail_open
  }
}
