# Common mistakes

- **Moving the template to the root `templates/` folder.** It makes the plan succeed, but the module is no longer
  self-contained; anybody reusing it from another project would miss the file.
- **Using `path.cwd`.** It depends on where Terraform is run from, which is exactly what `path.module` and `path.root`
  are meant to avoid.
- **Hard-coding `"../../audio/..."`.** It happens to work from this directory and breaks when the module is called from a
  different place.
- **Switching both paths to `path.module`.** The template is found, but the scripts are written inside the module folder.
