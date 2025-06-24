resource "null_resource" "wait_for_servicemonitor_crd" {
  depends_on = [helm_release.kube_prometheus_stack]

  provisioner "local-exec" {
    command = <<EOT
for i in {1..30}; do
  kubectl get crd servicemonitors.monitoring.coreos.com && exit 0
  echo "Waiting for ServiceMonitor CRD..."
  sleep 5
done
echo "CRD ServiceMonitor not found after timeout!" >&2
exit 1
EOT
  }
}

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
          port     = "http"
          path     = "/"
          interval = "15s"
        }
      ]
      namespaceSelector = {
        matchNames = [kubernetes_namespace.monitoring.metadata[0].name]
      }
    }
  }
  depends_on = [null_resource.wait_for_servicemonitor_crd]
}
