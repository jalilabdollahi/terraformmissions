variable "crew" {
  description = "Sailor name => role."
  type        = map(string)
  default = {
    mara  = "captain"
    joss  = "deckhand"
    pim   = "deckhand"
    odile = "engineer"
  }
}
