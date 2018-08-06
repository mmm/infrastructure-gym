
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

resource "digitalocean_droplet" "jump" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "${var.droplet_name}-${count.index}"
  region = "ams3"
  size = "s-1vcpu-1gb"
  ssh_keys = ["${var.ssh_keys}"]
  tags = ["${var.tags}"]
  user_data = "${data.template_file.userdata.rendered}"
}

resource "digitalocean_floating_ip" "jump" {
  count = "${var.count}"
  region = "ams3"
  droplet_id = "${element(digitalocean_droplet.jump.*.id, count.index)}"
}

resource "digitalocean_firewall" "jump" {
  name = "22-and-443-from-anywhere"

  droplet_ids = ["${digitalocean_droplet.jump.*.id}"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "udp"
      port_range         = "63000-63100"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "icmp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}
