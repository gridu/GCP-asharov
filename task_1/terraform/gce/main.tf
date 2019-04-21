########################################################
#
# Name: main.tf
#
##########################################################

resource "google_compute_instance_template" "httpd" {
  name_prefix          = "${var.env}-${var.app_name}-"
  description          = ""
  instance_description = ""

  machine_type = "${var.instance_type}"
  region       = "${var.region}"

  tags = ["fw-${var.env}-${var.app_name}"]

  labels {
    name = "${var.env}-${var.app_name}-httpd"
  }

  lifecycle {
    create_before_destroy = true
  }

  disk {
    auto_delete  = true
    source_image = "${var.image_filter}"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

  metadata {
    name = "${var.env}-${var.app_name}-${count.index}"
  }
}

resource "google_compute_instance_group_manager" "httpd" {
  # Create as many IGMs as defined in 'zones' list
  count = "${var.max_instances >= 1 ? length(var.zones) : 0}"

  name        = "${var.env}-${var.app_name}-${count.index}"
  description = ""

  base_instance_name = "${var.env}-${var.app_name}"
  instance_template  = "${google_compute_instance_template.httpd.self_link}"

  # 'zone' is taken from 'zones' list, index is specified by resource index
  zone = "${element(var.zones,count.index)}"

  target_pools = [
    "${google_compute_target_pool.httpd.self_link}",
  ]

  auto_healing_policies {
    health_check      = "${google_compute_http_health_check.httpd.self_link}"
    initial_delay_sec = "${var.initial_delay}"
  }

  update_strategy = "ROLLING_UPDATE"

  rolling_update_policy {
    type           = "PROACTIVE"
    minimal_action = "RESTART"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "check_group_stability" {
  count      = "${var.max_instances >= 1 ? length(var.zones) : 0}"
  depends_on = ["google_compute_instance_group_manager.httpd"]

  triggers {
    everytime  = "${uuid()}"
    sleep_time = "${max((2.0 * var.initial_delay), ((var.initial_delay * (var.max_instances + (floor(var.max_instances * var.max_surge_percent / 100.0)))) / (ceil(var.max_instances * var.max_surge_percent / 100.0))))}"
  }

  # Wait until group is created/updated and stable
  provisioner "local-exec" {
    command = "gcloud compute instance-groups managed wait-until-stable ${var.env}-httpd-${count.index} --zone ${element(var.zones,count.index)} --timeout ${self.triggers.sleep_time}"
  }
}

resource "google_compute_target_pool" "httpd" {
  name        = "${var.env}-httpd"
  description = ""
  instances   = []

  health_checks = [
    "${google_compute_http_health_check.httpd.name}",
  ]

  session_affinity = "NONE"
}

resource "google_compute_http_health_check" "httpd" {
  name                = "${var.env}-httpd"
  description         = ""
  timeout_sec         = "${var.readiness_timeout}"
  check_interval_sec  = "${var.readiness_check_interval}"
  healthy_threshold   = "${var.readiness_healthy_threshold}"
  unhealthy_threshold = "${var.readiness_unhealthy_threshold}"
  port                = "${var.app_port}"
  request_path        = "/health"
}

# Autoscaler
resource "google_compute_autoscaler" "httpd" {
  count = "${var.max_instances >= 1 ? length(var.zones) : 0}"

  name        = "${var.env}-httpd-${count.index}"
  description = ""

  zone   = "${element(var.zones, count.index)}"
  target = "${element(google_compute_instance_group_manager.httpd.*.self_link,count.index)}"

  autoscaling_policy = {
    max_replicas    = "${var.max_instances}"
    min_replicas    = "${var.min_instances}"
    cooldown_period = "${var.cooldown_period}"

    cpu_utilization {
      target = "${var.cpu_utilization}"
    }
  }
}

### Load Balancer
#

resource "google_compute_health_check" "httpd" {
  name        = "${var.env}-${var.app_name}-readiness"
  description = ""

  timeout_sec         = "${var.readiness_timeout}"
  check_interval_sec  = "${var.readiness_check_interval}"
  healthy_threshold   = "${var.readiness_healthy_threshold}"
  unhealthy_threshold = "${var.readiness_unhealthy_threshold}"

  http_health_check {
    port         = "${var.app_port}"
    request_path = "/health"
  }
}

resource "google_compute_global_address" "httpd" {
  name = "httpd"
}

# LB forwarding rule
resource "google_compute_global_forwarding_rule" "httpd" {
  name = "${var.env}-httpd"

  ip_address = "${google_compute_global_address.httpd.address}"
  target     = "${google_compute_target_http_proxy.httpd.self_link}"

  port_range = "${var.app_port}"
}

resource "google_compute_target_http_proxy" "httpd" {
  name        = "httpd-proxy"
  description = ""
  url_map     = "${google_compute_url_map.httpd.self_link}"
}

resource "google_compute_url_map" "httpd" {
  name            = "httpd"
  description     = ""
  default_service = "${google_compute_backend_service.httpd.self_link}"
}

resource "google_compute_backend_service" "httpd" {
  name        = "${var.env}-${var.app_name}"
  description = ""
  protocol    = "HTTP"

  backend {
    group = "${element(google_compute_instance_group_manager.httpd.*.instance_group,0)}"
  }

  backend {
    group = "${element(google_compute_instance_group_manager.httpd.*.instance_group,1)}"
  }

  backend {
    group = "${element(google_compute_instance_group_manager.httpd.*.instance_group,2)}"
  }

  health_checks = [
    "${google_compute_health_check.httpd.self_link}",
  ]
}

### Ingress fw rule
resource "google_compute_firewall" "httpd_ingress" {
  description = "The (external) ingress GCE firewall rules"
  direction   = "INGRESS"
  name        = "${var.env}-${var.app_name}-external-ingress"
  network     = "default"

  allow {
    protocol = "tcp"

    ports = [
      "22",
      "80",
      "443",
    ]
  }

  target_tags = ["fw-${var.env}-${var.app_name}"]
}
