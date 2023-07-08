resource "google_compute_region_network_endpoint_group" "negfetchdata1" {
  name                  = "negfetchdata1"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  project = var.project_id
  cloud_function {
    function = "fetchData"
  }
}
resource "google_compute_region_network_endpoint_group" "negfetchdata2" {
  name                  = "negfetchdata2"
  network_endpoint_type = "SERVERLESS"
  region                = "northamerica-northeast1"
  cloud_function {
    function = "fetchData"
  }
  project = var.project_id
}
resource "google_compute_backend_service" "backendfetchdata" {
  connection_draining_timeout_sec = 0
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  locality_lb_policy              = "ROUND_ROBIN"
  name                            = "backendfetchdata"
  port_name                       = "http"
  project                         = var.project_id
  protocol                        = "HTTPS"
  session_affinity                = "NONE"
  timeout_sec                     = 30
    backend {
    group = google_compute_region_network_endpoint_group.negfetchdata1.self_link
  }

  backend {
    group = google_compute_region_network_endpoint_group.negfetchdata2.self_link
  }
}
resource "google_compute_url_map" "serverlesshttploadbalancer" {
  default_service = google_compute_backend_service.defaultbackend.self_link
  name = "serverlesshttploadbalancer"
  project = var.project_id
  host_rule {
    hosts        = ["montreal_college"]
    path_matcher = "path-matcher"
  }
}
  path_matcher {
    default_service = google_compute_backend_service.defaultbackend.self_link
    name            = "path-matcher"

        path_rule {
        paths   = ["/fetchdata"]
        service = google_compute_backend_service.backendfetchdata.self_link
        }
  }