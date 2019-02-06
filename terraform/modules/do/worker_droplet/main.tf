
data "template_file" "userdata" {
  template = "${file("../../../userdata/default.sh.tpl")}"
  vars = {
    project = "${var.ansible_tarball["project"]}"
    environment = "${var.ansible_tarball["environment"]}"
    region = "${var.ansible_tarball["region"]}"
    bucket = "${var.ansible_tarball["bucket"]}"
    ansible_role = "${var.ansible_tarball["role"]}"
    digitalocean_token = "${var.ansible_tarball["digitalocean_token"]}"
    ansible_vault_password = "${var.ansible_tarball["vault_password"]}"
    access_key = "${var.ansible_tarball["access_key"]}"
    secret_key = "${var.ansible_tarball["secret_key"]}"
  }
}

resource "digitalocean_droplet" "worker" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "${var.droplet_name}-${count.index}"
  region = "${var.region}"
  size = "s-4vcpu-8gb"
  ssh_keys = ["${var.ssh_keys}"]
  tags = ["${var.tags}", "${var.droplet_subnet}"]
  user_data = "${data.template_file.userdata.rendered}"
  private_networking = true
}

