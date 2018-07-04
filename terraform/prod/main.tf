provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["109.200.250.228/32"]
}

module "app" {
  source               = "../modules/app"
  public_key_path      = "${var.public_key_path}"
  private_key_path     = "${var.private_key_path}"
  zone                 = "${var.zone}"
  count                = "${var.count}"
  app_disk_image       = "${var.app_disk_image}"
  app_provision_status = "${var.app_provision_status}"
  database_int_ip      = "${module.db.db_internal_ip}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  count           = "${var.count}"
  db_disk_image   = "${var.db_disk_image}"
}
