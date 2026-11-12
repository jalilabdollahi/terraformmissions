# Walkthrough - Call Sign Chain

1. `terraform validate` reports *Missing resource instance key* on `random_pet.callsign.id`.
2. The pets are created from a set of names, so there are three of them. A single `wing_card` cannot
   refer to all three at once.
3. Use the instances as the collection for the next resource:
   ```hcl
   resource "local_file" "wing_card" {
     for_each = random_pet.callsign
     filename = "${path.module}/wings/${each.key}.txt"
     content  = "Cadet wing card - ${each.key}: call sign ${each.value.id}\n"
   }
   ```
4. Apply. Each card carries the call sign of the same-keyed pet. Run `terraform plan -var
   'cadets=["amira","dara"]'` to see Bram's pet and card go together and Dara's appear together.
