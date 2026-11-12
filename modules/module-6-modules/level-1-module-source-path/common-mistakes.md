# Common mistakes

- **Renaming the folder to `grading` instead of fixing the source.** It can work, but the mission is about the
  call; the validator also expects the folder modules/grader to stay where the rest of the farm expects it.
- **Writing `source = "./grader"`.** The path is relative to the root module directory, not to `modules/`.
- **Forgetting to re-run `terraform init` after editing `source`.** Module sources are resolved at init time.
- **Copying the label resource into main.tf.** That skips the module and removes `module.grading` from state.
