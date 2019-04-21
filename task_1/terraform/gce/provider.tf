########################################################
#
# Name: provider.tf
#
##########################################################

variable "credentials_file" {
  description = "Contents of the JSON file used to describe account credentials, downloaded from Google Cloud Console"
}

variable "project_id" {
  description = "The ID of the project to apply any resources to"
}

variable "region" {
  description = "The region to operate under"
}

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_id}"
  credentials = "${file(var.credentials_file)}"
  version     = "1.19.1"
}
