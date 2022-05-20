# Create static public ip for Web App Server VM
resource "google_compute_address" "wapsnode-static-ip-address" {
  name = "${var.tag}-static-ip-address"
}

# Setting up MATLAB Web App Server
#   Number of server instances - count
#   Instance Type              - machine_type
#   Firewall rules applicable  - tags
#   Boot Disk image            - image
#   Boot Disk Size             - size
#   Access & Permissions       - scopes
#   Startup script             - metadata_startup_script
#   VPC and Subnet             - network_interface
#   Disk for installation      - attached_disk

resource "google_compute_instance" "vm_waps_instance" {
  name = "${var.tag}-compute-for-waps"
  machine_type = var.machine_type
  tags = concat(var.network_tags , ["waps"]) 
  allow_stopping_for_update = true

boot_disk {
    initialize_params {
      image = "${var.imageProject}/${var.imageFamily}"
      size = 70
    }
  }

metadata = {
    ssh-keys = "${var.username}:${file(var.gce_ssh_key_file_path)}"
}

service_account {
  scopes = ["compute-rw", "storage-full", "cloud-platform", "logging-write", "monitoring-write", "userinfo-email" , "service-management", "service-control"]
}

metadata_startup_script = "gsutil cp gs://${var.scriptBucketName}/startup.sh . && sudo chmod 777 startup.sh && ./startup.sh ${var.scriptBucketName} ${var.runtimeBucketName} ${var.isoBucketName} ${var.Version} ${var.FIK} ${var.LicenseManagerHost} ${var.LicenseManagerPort} ${var.Agree_To_License}"

# Input Argument Reference
###############################################################################
#SCRIPT_BUCKET_NAME=$1     #RUNTIME_BUCKET_NAME=$2  #ISO_BUCKET_NAME=$3
#VERSION=$4     #FIK=$5    #LICENSE_MANAGER_IP=$7    #LICENSE_MANAGER_PORT=$8
###############################################################################

network_interface {
  subnetwork = var.subnetwork
  access_config {
    nat_ip = google_compute_address.wapsnode-static-ip-address.address
  }
}

lifecycle {
   ignore_changes = [attached_disk]
  }
}

# (c) 2022 MathWorks, Inc.
