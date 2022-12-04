provider "google" {
  project     = "copa-370223"
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "google_compute_instance" "default" {
  name         = "node-vm"
  machine_type = "f1-micro"
  zone         = var.zone
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKIN=false ansible-playbook -i hosts playbook.yaml -vvv"
  # }

  network_interface {
    network       = google_compute_network.vpc_network.id

    access_config { }
  }
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}


resource "google_compute_firewall" "node" {
  name    = "node-app-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "local_file" "inventory" {
    filename = "./hosts"
    content     = <<-EOF
    [server]
    ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip} ansible_connection=ssh ansible_user=${var.user}
    EOF
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
