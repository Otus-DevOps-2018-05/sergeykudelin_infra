resource "google_compute_instance" "db" {
  name         = "reddit-db${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  count        = "${var.count}"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  tags = ["reddit-db"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }
}
