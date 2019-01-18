
#provider "google" {
  ##credentials = "${file("~/.config/gcloud/credentials.db")}"
  #project = ""
  #region = "us-central1"
#}

#resource "google_compute_disk" "example" {
  ##count = 1
  #name = "example-disk-0"
  #project = ""
  #zone = "us-central1-a"
  #size = 10
  #type = "pd-standard"
#}

#resource "kubernetes_persistent_volume" "example" {
  #metadata {
    #name = "my-data-pv-0"
  #}
  #spec {
    #capacity {
      #storage = "500Gi"
    #}
    #access_modes = ["ReadWriteOnce"]
    #persistent_volume_source {
      #gce_persistent_disk {
        #pd_name = "my-data-disk"
        #fs_type = "ext4"
        ##partition = 0
      #}
    #}
  #}
#}

#resource "kubernetes_persistent_volume_claim" "example" {
  #metadata {
    #name = "example-disk-0-pvc"
  #}
  #spec {
    #access_modes = ["ReadWriteOnce"]
    #resources {
      #requests {
        #storage = "500Gi"
      #}
    #}
    #volume_name = "${kubernetes_persistent_volume.example.metadata.0.name}"
  #}
#}
