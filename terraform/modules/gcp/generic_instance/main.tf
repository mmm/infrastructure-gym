
data "template_file" "userdata" {
  template = "${file("../../../userdata/gcp/default.sh.tpl")}"
  vars = {
    project = "${var.ansible_tarball["project"]}"
    environment = "${var.ansible_tarball["environment"]}"
    region = "${var.ansible_tarball["region"]}"
    bucket = "${var.ansible_tarball["bucket"]}"
    ansible_role = "${var.ansible_tarball["role"]}"
    ansible_vault_password = "${var.ansible_tarball["vault_password"]}"
  }
}

resource "google_compute_instance" "generic_instance" {
  count = "${var.count}"
  name = "${var.name}-${count.index}"
  machine_type = "${var.instance_type}"
  zone = "${var.zone}"
  project     = "${var.gcp_project}"

  tags = ["${var.tags}"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  #// Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    network = "default"

    #access_config {
      #// Ephemeral IP
    #}
  }

  metadata {
    foo = "bar"
    sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "${data.template_file.userdata.rendered}"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  #ssh_keys = ["${var.ssh_keys}"]

  #provisioner "file" {
    #source = "../modules/instructor_droplet/provision.sh"
    #destination = "/tmp/provision.sh"
    #connection {
      #private_key = "${file("/home/mmm/.ssh/id_rsa")}"
    #}
  #}

  #provisioner "remote-exec" {
    #inline = [
      #"chmod +x /tmp/provision.sh",
      #"sudo /tmp/provision.sh",
    #]
    #connection {
      #private_key = "${file("/home/mmm/.ssh/id_rsa")}"
    #}
  #}
}
