#!/bin/bash
set -euxo pipefail

# -------- Install Docker --------
apt-get update -y
apt-get install -y docker.io docker-compose-plugin git

systemctl enable docker
systemctl start docker

# -------- EBS Mount --------
EBS_DEVICE="/dev/xvdf"
MOUNT_POINT="/data"

while [ ! -e $EBS_DEVICE ]; do
  sleep 5
done

if ! blkid $EBS_DEVICE; then
  mkfs.ext4 $EBS_DEVICE
fi

mkdir -p $MOUNT_POINT

mount $EBS_DEVICE $MOUNT_POINT || true

if ! grep -q "$EBS_DEVICE $MOUNT_POINT" /etc/fstab; then
  echo "$EBS_DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
fi

# -------- Clone repo --------
cd /opt

git clone https://github.com/adeel-aws/Zabbix-Monitoring-Platform.git

cd Zabbix-Monitoring-Platform/docker

# -------- Start stack --------
docker compose up -d