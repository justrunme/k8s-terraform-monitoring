# ServiceMonitor (создастся только после появления CRD)
resource "kubernetes_manifest" "test_app_servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "test-app"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      labels = {
        release = helm_release.kube_prometheus_stack.name
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "test-app"
        }
      }
      endpoints = [
        {
          port     = "http"     # Имя порта в Service!
          path     = "/"
          interval = "15s"
        }
      ]
      namespaceSelector = {
        matchNames = [kubernetes_namespace.monitoring.metadata[0].name]
      }
    }
  }
  depends_on = [helm_release.kube_prometheus_stack]
}
