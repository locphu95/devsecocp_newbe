#!/bin/bash

# Tạo host keys nếu chưa có
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Khởi động SSH daemon
exec /usr/sbin/sshd -D