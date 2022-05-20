# public ip for web app server instance created
output "waps_node_public_ip" {
  value = google_compute_instance.vm_waps_instance.network_interface.0.access_config.0.nat_ip
}

# Hostname for web app server instance
output "name" {
   value = google_compute_instance.vm_waps_instance.name
}


# reource self link for web app server instance
output "Selflink" {
  value = google_compute_instance.vm_waps_instance.self_link
}

# resource id for web app server instance
output "id" {
   value = google_compute_instance.vm_waps_instance.id
}

# (c) 2022 MathWorks, Inc.
