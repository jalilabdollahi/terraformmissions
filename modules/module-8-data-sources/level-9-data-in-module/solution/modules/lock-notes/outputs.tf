output "reading" {
  description = "The keeper's latest reading as an object: keeper, level_cm, gates_open"
  value = {
    keeper     = local.parsed.keeper
    level_cm   = local.parsed.level_cm
    gates_open = local.parsed.gates_open
  }
}
