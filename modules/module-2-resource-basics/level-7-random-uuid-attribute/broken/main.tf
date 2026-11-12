# Parcel locker tracking for Quillfeather Post.
# Every locker drop gets a UUID that the customer receives by SMS and that the
# locker's keypad accepts as a pickup code.

resource "random_uuid" "drop_id" {}

resource "random_uuid" "receipt_id" {}

resource "local_file" "locker_ticket" {
  filename = "${path.module}/lockers/ticket.json"
  content = jsonencode({
    locker  = "B-14"
    drop_id = random_uuid.drop_id.value
    receipt = random_uuid.receipt_id.value
  })
}

output "pickup_code" {
  value = random_uuid.drop_id.value
}
