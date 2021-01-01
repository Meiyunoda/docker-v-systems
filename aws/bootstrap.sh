#!/bin/bash
# AWS r5d r5ad r5dn ubuntu 20.04

sudo apt update
sudo apt install -y docker.io acl
# Avoid adding ubuntu to docker group
# https://askubuntu.com/a/982187
sudo setfacl -m user:ubuntu:rw /var/run/docker.sock

if [ -d ~/ssd ]; then
    echo "SSD mount already exists, bootstrapped already?"
    exit 1
fi

mkdir ~/ssd
sudo mkfs.ext4 /dev/nvme1n1
echo "/dev/nvme1n1 /home/ubuntu/ssd auto noatime 0 0" | sudo tee -a /etc/fstab
sudo mount -a

echo "Bootstrap done."
docker --version
