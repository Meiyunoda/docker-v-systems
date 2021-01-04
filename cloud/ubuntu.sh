#!/bin/bash
# For servers with root mount as storage
# Ubuntu 20.04 LTS

if [ "$USER" != "ubuntu" ]; then
    echo "Not user ubuntu, please login as user ubuntu!"
    exit 1
fi

sudo apt update
sudo apt install -y vim docker.io acl

# Avoid adding ubuntu to docker group
# https://askubuntu.com/a/982187
sudo setfacl -m user:ubuntu:rw /var/run/docker.sock

# Disable ssh password authentication
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
grep PasswordAuthentication /etc/ssh/sshd_config
sudo service ssh restart
echo "SSH password authentication disabled."

docker --version
echo "Bootstrap done."
