
variable "gcp_project" {
  default = ""
}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-b"
}

variable "name" {
  default = "gpuinstance"
}

variable "count" {
  default = 1
}

variable "instance_type" {
  default = "f1-micro"
}

variable "ssh_keys" {
  default = []
}

variable "tags" {
  default = []
}

variable "ansible_tarball" {
  default = {}
}

output "instance_ips" {
  #value = "${join(" ", google_compute_instance.www.*.network_interface.0.access_config.0.assigned_nat_ip)}"
  value = [ "${google_compute_instance.generic_instance.*.network_interface.0.access_config.0.assigned_nat_ip}" ]
}
