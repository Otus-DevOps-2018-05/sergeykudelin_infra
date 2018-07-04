variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the private key used for provisioner connect"
}

variable "count" {
  description = "Default numbers of VMs"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable "app_provision_status" {
  description = "enable or disable provision scripts"
  default     = "true"
}

variable "puma_env" {
  description = "Path to env file for systemd puma unit"
  default     = "/tmp/puma.env"
}

variable "database_int_ip" {
  description = "Database internal ip"
}
