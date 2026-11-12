# Walkthrough: Ladder Export Guards

1. **Validate.** `Error: Invalid reference in precondition ... Configuration for data.local_file.ladder
   may not refer to itself.`
2. **Split the two rules by when they can run.**
   - "does the file exist and is it a .csv?" depends only on `var.ladder_file`, so it can run before the
     read: a `precondition`.
   - "does the content start with the header?" needs the data that was read: a `postcondition` using `self`.
3. **Write them.**
   ```hcl
   lifecycle {
     precondition {
       condition     = endswith(var.ladder_file, ".csv") && fileexists("${path.module}/${var.ladder_file}")
       error_message = "The ladder file must be an existing .csv export."
     }
     postcondition {
       condition     = startswith(self.content, "rank,player,rating")
       error_message = "The ladder export must start with the header rank,player,rating."
     }
   }
   ```
4. **Try the guards.** `terraform plan -var ladder_file=data/missing.csv` stops with
   `Resource precondition failed`; `-var ladder_file=data/ladder-bad.csv` stops with
   `Resource postcondition failed`. Apply the default and type `check`.
