resource "kubernetes_deployment" "app" {
  metadata {
    name = "app"
    labels = {
      app = "app-sec"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "app-sec"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-sec"
        }
      }
      spec {
        container {
          name  = "app"
          image = "${aws_ecr_repository.app.repository_url}:latest"

          env_from {
            secret_ref {
              name = kubernetes_secret.db_credentials.metadata[0].name
            }
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
