# Common mistakes

- **Forgetting the quotes.** `-replace=random_integer.door_code["booth"]` loses the inner quotes in the shell and Terraform reports no matching instance.
- **Replacing the whole resource, not the instance.** `-replace=random_integer.door_code` is invalid for a `for_each` resource, and bumping min/max in the code would regenerate all four codes.
- **Adding `keepers` to the resource.** That changes code for a one-off rotation and, because it affects every instance, regenerates every code.
- **Running `terraform destroy -target` and then `apply`.** It works but removes the crew card's other dependencies for a while and is much riskier than one command.
- **Using `terraform taint` and stopping.** The object is only marked; nothing is replaced until the next apply.
