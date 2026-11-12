variable "clues" {
  description = "Clue texts in the order guests find them."
  type        = list(string)
  default = [
    "The candlestick was moved at midnight",
    "The butler polished the silver twice",
    "The third wine glass is cracked",
    "Turn the study key to the left",
  ]
}
