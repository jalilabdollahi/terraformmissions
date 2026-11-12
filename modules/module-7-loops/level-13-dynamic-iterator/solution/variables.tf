variable "classes" {
  description = "Classes in the order they are taught."
  type = list(object({
    file = string
    text = string
  }))
  default = [
    { file = "monday-bowing.txt", text = "Rei means bow." },
    { file = "tuesday-counting.txt", text = "Ichi, ni, san." },
    { file = "wednesday-stances.txt", text = "Zenkutsu is a forward stance." },
  ]
}
