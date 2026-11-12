# Walkthrough — Score Folio Contents

1. **First error.** `terraform plan` says `Invalid index ... var.scores ... the given key does not
   identify an element in this collection value`. The filename uses `count.index + 1`, so instance 2
   asks for a fourth piece. Instances are numbered from 0:
   `filename = "${path.module}/scores/${var.scores[count.index]}.txt"`.
2. **Second error.** `Missing resource instance key` for `data.local_file.score.content`: with
   `count` set, the address refers to a list of instances. Iterate over it:
   ```hcl
   titles = [for g in data.local_file.score : trimspace(regex("title: (.*)", g.content)[0])]
   ```
   (`data.local_file.score[0].content` would be a single instance.)
3. `terraform apply` -> `total_notes = 3580`. Type `check`.
