# sử dụng ubuntu làm base image
FROM ubuntu:22.04

# thiết lập biến môi trường
ENV DEBIAN_FRONTEND=noninteractive

# cập nhật và cài đặt các công cụ cần thiết
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
    docker.io \
    && apt clean

# tạo user dev và cấu hình sudo
RUN useradd -ms /bin/bash dev \
    && echo "dev:devpassword" | chpasswd \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# tạo thư mục .ssh cho user dev
RUN mkdir -p /home/dev/.ssh \
    && chown dev:dev /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# tạo thư mục cần thiết cho SSH
RUN mkdir /var/run/sshd

# cấu hình SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# tạo thư mục làm việc
RUN mkdir -p ~/workspace

# mở cổng SSH
EXPOSE 22

# dùng entrypoint để khởi động SSH đúng cách
ENTRYPOINT ["/entrypoint.sh"]
