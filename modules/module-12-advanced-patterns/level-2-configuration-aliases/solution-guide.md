# Walkthrough: Back Wall Spare Reel

1. **Reproduce.** `terraform validate` fails with
   `Error: Provider configuration not present ... module.reels.provider["registry.terraform.io/hashicorp/random"].spare`.
2. **Understand.** The child resource says `provider = random.spare`, but a module has no
   `spare` configuration: the caller never passed one, and the module never said it expects one.
3. **Declare the slot in the child.** Create `modules/reel_stock/terraform.tf`:
   ```hcl
   terraform {
     required_providers {
       random = {
         source                = "hashicorp/random"
         configuration_aliases = [random.spare]
       }
     }
   }
   ```
4. **Fill the slot in the root.**
   ```hcl
   providers = {
     random       = random
     random.spare = random.back_wall
   }
   ```
5. `terraform init` is not needed again. Run `terraform validate` (silent), `terraform apply`, then `check`.
