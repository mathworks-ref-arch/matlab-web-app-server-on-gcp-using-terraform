# allow traffic from
resource "google_compute_firewall" "allow-waps" {
  name = "${var.tag}-fw-allow-ports"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = [var.waps_port,"22"]
  }
  target_tags = ["waps"]
  source_ranges = var.allowclientip
}


# (c) 2022 MathWorks, Inc.
