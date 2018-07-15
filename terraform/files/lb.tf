resource "google_compute_http_health_check" "healthcheck" {
  name               = "healthcheck"
  port               = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_target_pool" "reddit-srv" {
  name          = "reddit-srv"
  instances     = ["${google_compute_instance.app.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.healthcheck.name}"]
}

resource "google_compute_forwarding_rule" "forward" {
  name       = "forward"
  target     = "${google_compute_target_pool.reddit-srv.self_link}"
  port_range = "9292"
}
