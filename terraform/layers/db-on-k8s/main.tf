terraform {
  backend "s3" {}
}

provider "kubernetes" {}

#resource "kubernetes_persistent_volume_claim" "example" {
	#metadata {
		#name = "exampleclaimname"
	#}
	#spec {
		#access_modes = ["ReadWriteMany"]
		#resources {
			#requests {
				#storage = "5Gi"
			#}
		#}
		#volume_name = "${kubernetes_persistent_volume.example.metadata.0.name}"
	#}
#}

#resource "kubernetes_persistent_volume" "example" {
	#metadata {
		#name = "examplevolumename"
	#}
	#spec {
		#capacity {
			#storage = "10Gi"
		#}
		#access_modes = ["ReadWriteMany"]
		#persistent_volume_source {
			#gce_persistent_disk {
				#pd_name = "test-123"
			#}
		#}
	#}
#}

data "null_data_source" "env_map" {
  count = "${length(var.db_env)}"
  inputs = {
    name = "${ lookup(var.db_env[count.index], "name", "") }"
    value = "${ lookup(var.db_env[count.index], "value", "") }"
  }
}

data "null_data_source" "dbpw" {
  inputs = {
    value = "${element(matchkeys(data.null_data_source.env_map.*.outputs.value,
                                 data.null_data_source.env_map.*.outputs.name,
                                 list("DB_PASSWORD")),0)}"
  }
}

resource "helm_release" "db" {
    name      = "myapp"
    chart     = "stable/postgresql"
    version   = "2.7.6"

    set {
        name  = "postgresqlPassword"
        value = "${data.null_data_source.dbpw.outputs.value}"
    }

    set {
        name  = "postgresqlDatabase"
        value = "placeholder"
    }

    set {
        name  = "metrics.enabled"
        value = "true"
    }

    #set {
        #name = "persistence.existingClaim"
        ##value = "data-myapp-postgresql-0"
        #value = "${kubernetes_persistent_volume_claim.example.metadata.0.name}"
    #}
}
