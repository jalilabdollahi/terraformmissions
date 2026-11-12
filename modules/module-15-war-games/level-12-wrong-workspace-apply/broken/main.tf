# Harwick Rally stage marshal posts.
# One configuration, two Terraform workspaces: "prod" and "staging". Each post gets a
# radio key and a card file that race control loads. The list of posts per
# environment lives in env/<environment>.json (staging has no posts rolled out yet).

locals {
  # Hotfix HF-31 pinned the environment while debugging a prod-only issue.
  env    = "prod"
  posts  = jsondecode(file("${path.module}/env/${local.env}.json")).posts
}

# One seed per workspace, created long before the post rollout.
resource "random_id" "region_seed" {
  byte_length = 6
}

resource "random_id" "post_key" {
  for_each    = local.posts
  byte_length = 4
}

resource "local_file" "post_card" {
  for_each = local.posts
  filename = "${path.module}/marshals/${local.env}/${each.key}.card"
  content  = "post ${each.key} channel ${each.value} key ${random_id.post_key[each.key].hex}\n"
}

output "region_seed" {
  value = random_id.region_seed.hex
}

output "post_keys" {
  value = { for k, r in random_id.post_key : k => r.hex }
}
