variable "clues" {
  description = "Clue texts in the order players find them."
  type        = list(string)
  default = [
    "The pendulum stops at midnight",
    "Count the brass gears twice",
    "The third drawer sticks",
    "Wind the key to the left",
  ]
}
