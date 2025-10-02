# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Cài công cụ cơ bản
RUN apt update && apt install -y \
    curl \
    git \
    vim \
    openssh-client \
    openssh-server \
    gnupg \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    lsb-release \
    sudo \
    unzip \
    default-jdk \
    sqlite3 \
    python3-pip \
    docker.io \
    iptables \
    && apt clean

# Tạo user dev
RUN useradd -ms /bin/bash dev \
    && echo "dev:devpassword" | chpasswd \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSH setup
RUN mkdir -p /home/dev/.ssh /var/run/sshd \
    && chown dev:dev /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Entrypoint
COPY check_devsecops.sh /check_devsecops.sh
RUN chmod +x /check_devsecops.sh


# Workspace
RUN mkdir -p /home/dev/workspace

# Gitea
RUN curl -L -o /usr/local/bin/gitea https://dl.gitea.io/gitea/1.21.4/gitea-1.21.4-linux-amd64 \
    && chmod +x /usr/local/bin/gitea

RUN apt-get update && apt-get install -y gnupg curl \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /etc/apt/keyrings/jenkins.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list \
    && apt-get update \
    && apt-get install -y jenkins \
    && mkdir -p /var/jenkins_home \
    && chown -R dev:dev /var/jenkins_home


# Trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Semgrep
RUN pip install semgrep

# SonarScanner
RUN curl -L -o /opt/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && unzip /opt/sonar-scanner.zip -d /opt/ \
    && ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Docker Registry (chạy bằng docker CLI sau khi container khởi động)
RUN mkdir -p /opt/registry

# Tải K3s binary mà không cấu hình systemd
RUN curl -L https://github.com/k3s-io/k3s/releases/latest/download/k3s -o /usr/local/bin/k3s \
    && chmod +x /usr/local/bin/k3s \
    && ln -s /usr/local/bin/k3s /usr/local/bin/kubectl


# Mở cổng dịch vụ
EXPOSE 22 3000 8080 5000 6443

CMD ["bash", "/entrypoint.sh"]