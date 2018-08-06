
variable "digitalocean_token" {}

output "digitalocean_tag_tfmanaged_id" {
  value = "${digitalocean_tag.tfmanaged.id}"
}
output "digitalocean_tag_dev_id" {
  value = "${digitalocean_tag.dev.id}"
}
output "digitalocean_tag_jump_id" {
  value = "${digitalocean_tag.jump.name}"
}
