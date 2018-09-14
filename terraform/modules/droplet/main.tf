
data "template_file" "userdata" {
  template = "${file("../../userdata/default.sh.tpl")}"
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

resource "digitalocean_volume" "home" {
  count = "${var.count}"
  name = "${var.droplet_name}-${count.index}-home"
  region = "${var.region}"
  size = 500
}

resource "digitalocean_droplet" "generic" {
  count = "${var.count}"
  image = "ubuntu-16-04-x64"
  name = "${var.droplet_name}-${count.index}"
  region = "${var.region}"
  size = "s-1vcpu-1gb"
  ssh_keys = ["${var.ssh_keys}"]
  tags = ["${var.tags}", "${var.droplet_subnet}"]
  volume_ids = ["${element(digitalocean_volume.home.*.id, count.index)}"]
  user_data = "${data.template_file.userdata.rendered}"
  private_networking = true
}

resource "digitalocean_firewall" "firewall_inside_to_inside" {
  name = "${var.project}-${var.environment}-inside-to-inside"

  tags = ["${var.droplet_subnet}"]

  inbound_rule = [
    {
      protocol           = "icmp"
      port_range         = "1-65535"
      source_tags        = ["${var.droplet_subnet}"]
    },
    {
      protocol           = "tcp"
      port_range         = "1-65535"
      source_tags        = ["${var.droplet_subnet}"]
    },
    {
      protocol           = "udp"
      port_range         = "1-65535"
      source_tags        = ["${var.droplet_subnet}"]
    },
  ]

  outbound_rule = [
    {
      protocol           = "icmp"
      port_range         = "1-65535"
      destination_tags   = ["${var.droplet_subnet}"]
    },
    {
      protocol           = "tcp"
      port_range         = "1-65535"
      destination_tags   = ["${var.droplet_subnet}"]
    },
    {
      protocol           = "udp"
      port_range         = "1-65535"
      destination_tags   = ["${var.droplet_subnet}"]
    },
  ]
}

resource "digitalocean_firewall" "firewall_inside_to_outside" {
  name = "${var.project}-${var.environment}-inside-to-outside"

  tags = ["${var.droplet_subnet}"]

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
