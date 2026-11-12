# Walkthrough - One Closure Shown

1. `terraform apply` then `terraform output closure_paths`: a single string,
   `"./closures/harbour-heist.txt"`. `closure_count` correctly says 4.
2. The expression `local_file.closure[0].filename` selects instance 0 only. It would also fail outright
   with an out-of-range error if the list of shoots were empty.
3. Replace the index with the splat operator:
   ```hcl
   value = local_file.closure[*].filename
   ```
   (`[for c in local_file.closure : c.filename]` is the same thing written out.)
4. Apply: the output is now a four-element list. `terraform plan -var 'shoots=[]'` gives `[]` instead of
   an error.
