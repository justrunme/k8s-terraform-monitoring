resource "kubernetes_deployment" "test_app" {
  metadata {
    name      = "test-app"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "test-app"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "test-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "test-app"
        }
      }
      spec {
        container {
          name  = "test-app"
          image = "prom/node-exporter"
          port {
            container_port = 9100
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test_app" {
  metadata {
    name      = "test-app"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "test-app"
    }
  }
  spec {
    selector = {
      app = "test-app"
    }
    port {
      name        = "metrics"  # ВАЖНО! Для ServiceMonitor
      port        = 9100
      target_port = 9100
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}

