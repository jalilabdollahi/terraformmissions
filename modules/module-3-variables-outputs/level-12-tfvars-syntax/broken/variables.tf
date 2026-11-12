variable "tour_name" {
  description = "Name of the tour company on the sailing notice."
  type        = string
}

variable "seat_count" {
  description = "Number of passenger seats."
  type        = number
}

variable "sailing_times" {
  description = "Departure times (HH:MM), in order."
  type        = list(string)
}

variable "lifejackets_required" {
  description = "Are lifejackets compulsory on deck for all passengers?"
  type        = bool
}
