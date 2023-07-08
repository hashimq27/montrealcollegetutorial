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