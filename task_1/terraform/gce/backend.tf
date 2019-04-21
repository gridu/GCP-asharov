########################################################
#
# Name: backend.tf
#
##########################################################

terraform {
  backend "gcs" {
    bucket      = "gcp-course-terraform-states"
    prefix      = "terraform/state/"
    project     = "unified-booster-218722"
    credentials = "/Users/asharov/.terraform/personal.json"
  }
}
