variable "documents" {
  description = "File name inside the zip => file text."
  type        = map(string)
  default = {
    "consent-form.txt"   = "I allow my child to join the trip."
    "packing-list.txt"   = "Raincoat, lunch, two pens."
    "emergency-card.txt" = "Call the school office first."
  }
}
