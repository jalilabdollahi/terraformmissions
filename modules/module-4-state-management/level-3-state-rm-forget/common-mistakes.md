# Common mistakes

- **Deleting the resource block and running `terraform apply`.** Terraform destroys the file. The breeders' association loses its stud book.
- **Running `terraform state rm` but leaving the block in main.tf.** The plan wants to create the resource again and would overwrite the file with our version.
- **Removing the wrong address.** `terraform state rm local_file.vet_log` forgets the log instead; the plan then wants to recreate it.
- **Using `terraform destroy -target`.** That is the opposite of forgetting: it deletes the real file.
- **Adding a `removed` block.** It is a valid modern alternative, but this mission is about the state CLI and the validator rejects it.
