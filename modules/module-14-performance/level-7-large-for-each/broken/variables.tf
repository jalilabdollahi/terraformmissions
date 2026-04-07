# BUG: The map values are strings, but random_string.length expects a number.
# Fix: change type to map(number) and remove quotes from all values.
variable "token_lengths" {
  type = map(string)
  default = {
    token_01 = "8"
    token_02 = "10"
    token_03 = "12"
    token_04 = "8"
    token_05 = "16"
    token_06 = "8"
    token_07 = "10"
    token_08 = "12"
    token_09 = "8"
    token_10 = "16"
    token_11 = "8"
    token_12 = "10"
    token_13 = "12"
    token_14 = "8"
    token_15 = "16"
    token_16 = "8"
    token_17 = "10"
    token_18 = "12"
    token_19 = "8"
    token_20 = "16"
  }
}
