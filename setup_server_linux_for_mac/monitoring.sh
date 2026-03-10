#!/bin/bash

echo "📊 Triển khai Prometheus + Grafana trên K3s..."

# Đảm bảo KUBECONFIG đã được thiết lập
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Kiểm tra Helm đã cài chưa
if ! command -v helm &> /dev/null; then
    echo "❌ Helm chưa được cài. Vui lòng cài Helm trước."
    exit 1
fi

# Thêm Helm repo Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Tạo namespace monitoring nếu chưa có
kubectl get ns monitoring &> /dev/null || kubectl create ns monitoring

# Triển khai kube-prometheus-stack
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

echo "⏳ Chờ K3s khởi động..."
sleep 30
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get nodes || { echo "❌ K3s chưa sẵn sàng"; exit 1; }

echo "⏳ Đang chờ Pod khởi động..."
kubectl -n monitoring wait --for=condition=Ready pod --all --timeout=180s

echo "✅ Monitoring đã được triển khai!"

# Lấy thông tin truy cập Grafana
echo "🔐 Thông tin truy cập Grafana:"
GRAFANA_POD=$(kubectl -n monitoring get pods -l app.kubernetes.io/name=grafana -o jsonpath="{.items[0].metadata.name}")
kubectl -n monitoring port-forward $GRAFANA_POD 3000:3000 &

echo "🌐 Truy cập Grafana tại: http://localhost:3000"
echo "🧑 Username: admin"
echo "🔑 Password: $(kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)"


