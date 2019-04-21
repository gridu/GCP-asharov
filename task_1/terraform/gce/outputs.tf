########################################################
#
# Name: outputs.tf
#
# Description: Output values of the Terraform module
#
##########################################################

output "load_balancer_address" {
  value = "${element(concat(google_compute_global_forwarding_rule.httpd.*.ip_address, list("")), 0)}"
}
