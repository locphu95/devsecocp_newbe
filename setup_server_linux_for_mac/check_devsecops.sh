#!/bin/bash

echo "🔍 Kiểm tra các dịch vụ DevSecOps đã setup..."

# SSH
echo -n "✅ SSH: "
pgrep -x sshd >/dev/null && echo "Đang chạy" || echo "Không chạy"

# Jenkins
echo -n "✅ Jenkins: "
pgrep -f jenkins >/dev/null && echo "Đang chạy" || echo "Không chạy"

# Gitea
echo -n "✅ Gitea: "
pgrep -f gitea >/dev/null && echo "Đang chạy" || echo "Không chạy"

# Docker Registry
echo -n "✅ Docker Registry: "
docker ps --format '{{.Names}}' | grep -q registry && echo "Đang chạy" || echo "Không chạy"

# K3s
echo -n "✅ K3s (Kubernetes): "
pgrep -f k3s >/dev/null && echo "Đang chạy" || echo "Không chạy"

# Trivy
echo -n "✅ Trivy: "
command -v trivy >/dev/null && echo "Đã cài" || echo "Chưa cài"

# Semgrep
echo -n "✅ Semgrep: "
command -v semgrep >/dev/null && echo "Đã cài" || echo "Chưa cài"

# SonarScanner
echo -n "✅ SonarScanner: "
command -v sonar-scanner >/dev/null && echo "Đã cài" || echo "Chưa cài"

# Kiểm tra kubectl kết nối K3s
echo -n "✅ kubectl cluster-info: "
kubectl cluster-info >/dev/null 2>&1 && echo "Kết nối OK" || echo "Không kết nối được"

echo "🎯 Kiểm tra hoàn tất!"
