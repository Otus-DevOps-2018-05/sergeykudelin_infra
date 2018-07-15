terraform {
  backend "gcs" {
    bucket = "infra-tf-backend"
    prefix = "terraform/tfstate/prod"
  }
}
