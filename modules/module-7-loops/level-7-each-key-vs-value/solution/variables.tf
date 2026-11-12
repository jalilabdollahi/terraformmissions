variable "crew" {
  description = "Operator name => role."
  type        = map(string)
  default = {
    mara  = "supervisor"
    joss  = "attendant"
    pim   = "attendant"
    odile = "mechanic"
  }
}
