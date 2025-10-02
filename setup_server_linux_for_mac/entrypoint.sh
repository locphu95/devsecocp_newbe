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
nohup gitea web > /var/log/gitea.log 2>&1 &

# Docker Registry
echo "[+] Starting Docker Registry..."
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# K3s
echo "[+] Starting K3s..."
/usr/local/bin/k3s server > /var/log/k3s.log 2>&1 &

echo "✅ Tất cả dịch vụ đã khởi động!"
tail -f /dev/null
