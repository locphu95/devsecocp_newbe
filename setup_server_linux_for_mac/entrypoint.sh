#!/bin/bash

echo "🔧 Khởi động môi trường DevSecOps..."

# SSH
echo "[+] Starting SSH service..."
service ssh start

# Jenkins
echo "[+] Starting Jenkins..."
service jenkins start

# Gitea
echo "[+] Starting Gitea..."
touch /var/log/gitea.log
chown dev:dev /var/log/gitea.log
su - dev -c "nohup gitea web > /var/log/gitea.log 2>&1 &"

# Docker Registry
echo "[+] Starting Docker Registry..."
docker ps | grep registry >/dev/null || docker run -d -p 5000:5000 --restart=always --name registry registry:2

# K3s
echo "[+] Starting K3s..."
/usr/local/bin/k3s server > /var/log/k3s.log 2>&1 &

# Monitoring stack
echo "[+] Deploying Prometheus + Grafana..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

echo "✅ Tất cả dịch vụ đã khởi động!"
tail -f /dev/null
