# Walkthrough - One Permit Shown

1. `terraform apply` then `terraform output permit_paths`: a single string,
   `"./permits/taco-tide.txt"`. `permit_count` correctly says 4.
2. The expression `local_file.permit[0].filename` selects instance 0 only. It would also fail outright
   with an out-of-range error if the list of trucks were empty.
3. Replace the index with the splat operator:
   ```hcl
   value = local_file.permit[*].filename
   ```
   (`[for p in local_file.permit : p.filename]` is the same thing written out.)
4. Apply: the output is now a four-element list. `terraform plan -var 'trucks=[]'` gives `[]` instead of
   an error.
