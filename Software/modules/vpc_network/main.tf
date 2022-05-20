# vpc for WAPS
resource "google_compute_network" "vpc_network" {
  name = "${var.tag}-waps-network"
  auto_create_subnetworks = false
  project = "${var.project}"
}
# (c) 2022 MathWorks, Inc.
