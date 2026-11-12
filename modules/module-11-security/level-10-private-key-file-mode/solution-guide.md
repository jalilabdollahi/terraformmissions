# Walkthrough — Marrowby Chimney Sweep Key

1. Apply, then `ls -l keys/` and `ssh-keygen -y -f keys/sweepround_ed25519`. The mode is `-rw-r--r--` and OpenSSH
   answers *WARNING: UNPROTECTED PRIVATE KEY FILE! Permissions 0644 ... are too open*.
2. The private key is created by `local_file.private_key` with `file_permission = "0644"`. Two problems: the mode, and the choice of resource.
   `local_sensitive_file` has the same arguments, but treats `content` as a secret so it is not shown in plans.
3. Replace it:
   ```hcl
   resource "local_sensitive_file" "private_key" {
     filename             = "${path.module}/keys/sweepround_ed25519"
     content              = tls_private_key.sweepround.private_key_openssh
     file_permission      = "0600"
     directory_permission = "0700"
   }
   ```
4. The public key's `local_file` also creates `keys/` (whichever resource runs first makes the folder), so add `directory_permission = "0700"` there as well. Its file stays `0644`; it is meant to be shared.
5. Delete the old private `local_file` block, apply (if `keys/` already exists with the old mode, remove the directory first so Terraform recreates it), and type `check`.
