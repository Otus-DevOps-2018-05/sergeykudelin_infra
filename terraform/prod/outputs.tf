#output "loadbalance_external_ip" {
#  value = "${google_compute_forwarding_rule.forward.ip_address}"
#}
#output "reddit_srv_external_ip" {
#  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
#}
#output "reddit_srv_external_ip" {
# value = "${module.app.app.*._external_ip}"
#}

output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}
