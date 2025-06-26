resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "58.6.0"

  # Можно кастомизировать values по желанию, пример:
  values = [
    <<EOF
grafana:
  adminPassword: "prom-operator"
  service:
    type: NodePort
    nodePort: 30090
prometheus:
  prometheusSpec:
    serviceMonitorSelector:
      matchLabels:
        release: kube-prometheus-stack
EOF
  ]
  wait    = true
  timeout = 600
  # Опционально: wait = true, timeout = 600
}
