# Kubernetes Monitoring with Terraform 📊

A Terraform-based solution to deploy and manage a Kubernetes monitoring stack on any conformant K8s cluster.

---

## 🚀 Overview

This repo automates the deployment of a complete monitoring stack—including **Prometheus**, **Grafana**, and **Loki**—using Terraform and Helm providers. It spin‑ups all core components, configures necessary data sources & dashboards, and exposes them via Kubernetes services or Ingress as needed.

---

## 🧩 Architecture

- **Prometheus**: Scrapes metrics from your Kubernetes cluster.
- **Node Exporter & Kube‑State‑Metrics**: Expose node-level and Kubernetes API metrics.
- **Grafana**: Visualizes metrics with preconfigured data sources and dashboards.
- **Loki**: Optional logging aggregation via Promtail and Loki stack.

Each component is deployed as a fully managed Kubernetes resource via Terraform.

---

## 📘 Contents

.
├── main.tf         # Terraform entrypoint & Helm provider definitions
├── variables.tf    # Input parameters (versions, namespaces, resource limits, etc.)
├── outputs.tf      # Output values (service endpoints, dashboard URLs)
├── locals.tf       # Computed locals for defaults or naming conventions
└── templates/      # Embedded Kubernetes manifests or Helm overrides

---

## 🛠️ Quick Start

### Prerequisites

- Kubernetes cluster (e.g. EKS, GKE, AKS, k3s)
- [Terraform](https://terraform.io) ≥ 0.13
- Helm provider and kubernetes providers configured
- `kubectl` access to your cluster

### Setup

```bash
git clone https://github.com/justrunme/k8s-terraform-monitoring.git
cd k8s-terraform-monitoring
terraform init

Configure Variables

Edit or create a terraform.tfvars with inputs like:

monitoring_namespace = "monitoring"
prometheus_version   = "14.0.0"
grafana_admin_user   = "admin"
grafana_admin_pass   = "supersecure"

You can also set values like resource limits, PVC size, or enable Loki via variables.

Deploy

terraform apply

Terraform will:
	1.	Create the monitoring namespace.
	2.	Deploy Prometheus via Helm or K8s manifests.
	3.	Initialize node-exporter and kube-state-metrics.
	4.	Deploy Grafana with preconfigured Prometheus data source.
	5.	(Optional) Enable and configure Loki & Promtail.
	6.	Expose dashboards via service or Ingress.

⸻

✅ Testing & Verification

After deploying:
	1.	Check namespace & pods

kubectl get ns monitoring
kubectl get pods -n monitoring


	2.	Access services
	•	Prometheus: kubectl port-forward svc/prometheus-service 9090:9090
	•	Grafana: kubectl port-forward svc/grafana-service 3000:3000
	3.	Confirm dashboards/data sources
Go to http://localhost:3000, login (admin / from terraform.tfvars), and verify that Prometheus is set up under Data Sources. Browse imported dashboards for node, cluster, and pod-level metrics.
	4.	Query logs (if Loki enabled)
Confirm Promtail is sending logs to Loki and use Grafana Explore or dedicated dashboards.
	5.	Destroy infrastructure

terraform destroy



⸻

🔧 Customization
	•	Helm Overrides: Modify values via templates or Helm set blocks in main.tf.
	•	Variable Tweaks: Adjust CPU, memory limits, storage size, ingress configuration, and admin credentials.
	•	Multiple Environments: Use workspaces or variable files (dev.tfvars, prod.tfvars) per cluster type.
	•	Enable Loki: Activate logging stream via variables—Paired with Grafana’s Loki datasource and dashboards.

⸻

🧪 CI/CD & Quality
	•	Run terraform fmt and terraform validate in CI (GitHub Actions).
	•	Optionally integrate pre-commit for linting and formatting.
Example: shellcheck for templates, tfsec for Terraform security checks.
