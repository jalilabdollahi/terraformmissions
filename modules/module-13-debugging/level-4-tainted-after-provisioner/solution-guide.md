# Walkthrough - Sprayer Flash Recovery

1. `terraform plan` shows `terraform_data.sprayer_firmware is tainted, so must be replaced`. That tells you *what* Terraform
   will do, not why the last attempt failed.
2. `terraform state show terraform_data.sprayer_firmware` confirms the `tainted` flag.
3. Run `terraform apply` once and read the provisioner output. It prints
   `flash: image file not found: ./image/firmware-4.2.1.bin` and then `exit status 3`.
4. `ls` shows the folder is `images/`. Correct `IMAGE_DIR` in `main.tf`.
5. `terraform apply` again. Terraform destroys the tainted object and creates a new one; the provisioner runs and writes
   `flashed/van-07.stamp`.
6. `terraform plan` is clean. Type `check`.

Avoid `terraform untaint`: the stamp was never written, and Terraform would never run the provisioner again.
