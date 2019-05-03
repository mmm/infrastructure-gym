
data "template_file" "userdata" {
  template = "${file("../../../userdata/do/default.sh.tpl")}"
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

resource "digitalocean_droplet" "bastion" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "${var.droplet_name}-${count.index}"
  region = "${var.region}"
  size = "s-1vcpu-1gb"
  ssh_keys = ["${var.ssh_keys}"]
  tags = ["${var.tags}", "${var.bastion_subnet}"]
  user_data = "${data.template_file.userdata.rendered}"
  private_networking = true
}

resource "digitalocean_floating_ip" "bastion" {
  count = "${var.count}"
  region = "${var.region}"
  droplet_id = "${element(digitalocean_droplet.bastion.*.id, count.index)}"
}

resource "digitalocean_firewall" "firewall_outside_to_bastion" {
  name = "${var.project}-${var.environment}-outside-to-bastion"

  tags = ["${var.bastion_subnet}"]

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

  outbound_rule = []
}

resource "digitalocean_firewall" "firewall_bastion_to_outside" {
  name = "${var.project}-${var.environment}-bastion-to-outside"

  tags = ["${var.bastion_subnet}"]

  inbound_rule = []

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
