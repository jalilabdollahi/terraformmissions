variable "lessons" {
  description = "Lessons in the order they are taught."
  type = list(object({
    file = string
    text = string
  }))
  default = [
    { file = "monday-greetings.txt", text = "Kaixo means hello." },
    { file = "tuesday-numbers.txt", text = "Bat, bi, hiru." },
    { file = "wednesday-food.txt", text = "Ogia is bread." },
  ]
}
