# Debrief — one codebase, many state locations

A **partial backend configuration** leaves arguments out of the `backend` block and supplies them when you run
`terraform init`: `-backend-config=file.hcl` for a file or `-backend-config="key=value"` for single settings. Common
reasons: the same code is deployed to several environments with different state keys, or settings such as
credentials must not be committed. The `backend` block itself cannot use variables, so this is the supported
mechanism.

What to remember:

- **Terraform validates the file against the backend's schema.** A wrong argument name (`file_path` instead of
  `path`) fails at init, before any state is touched.
- **The result is cached** in `.terraform/terraform.tfstate`, not in your code. A later plain `terraform init`
  keeps using it, but a fresh checkout, or a CI job, must pass the same `-backend-config` again. Wrap it in a
  Makefile or pipeline step so nobody forgets.
- **Changing it is a backend change.** Terraform asks whether to migrate existing state or `-reconfigure`.
  Choose according to where the state really is.
- **Combine sources:** several `-backend-config` flags are merged, later ones winning.

If a plan unexpectedly wants to create everything, check which backend settings the working directory was
initialised with before suspecting the code.
