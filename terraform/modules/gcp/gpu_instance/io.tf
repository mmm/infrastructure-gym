
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

variable "gpu_count" {
  default = 0
}

variable "gpu_type" {
  default = "nvidia-tesla-k80"
}

variable "ssh_keys" {
  default = []
}

variable "ansible_tarball" {
  default = {}
}

variable "tags" {
  default = []
}

output "instance_ips" {
  #value = "${join(" ", google_compute_instance.www.*.network_interface.0.access_config.0.assigned_nat_ip)}"
  value = [ "${google_compute_instance.gpu_instance.*.network_interface.0.access_config.0.assigned_nat_ip}" ]
}
