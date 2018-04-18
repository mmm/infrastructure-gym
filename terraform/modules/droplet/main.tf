data "template_file" "userdata" {
  template = "${file("../../userdata/default.sh.tpl")}"
  vars = {
    ansible_vault_password = "${var.ansible_tarball["vault_password"]}"
    access_key = "${var.ansible_tarball["access_key"]}"
    secret_key = "${var.ansible_tarball["secret_key"]}"
    region = "${var.ansible_tarball["region"]}"
    bucket = "${var.ansible_tarball["bucket"]}"
  }
}

resource "digitalocean_droplet" "generic_droplet" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "${var.droplet_name}-${count.index}"
  region = "sfo2"
  size = "s-2vcpu-4gb"
  ssh_keys = ["${var.ssh_keys}"]
  tags = ["${var.tags}"]
  user_data = "${data.template_file.userdata.rendered}"
}
