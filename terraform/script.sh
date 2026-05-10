#!/bin/bash
set -euxo pipefail

# -------- Install Docker --------
apt-get update -y
apt-get install -y docker.io git

systemctl enable docker
systemctl start docker

# -------- Optional EBS mount (keep your logic if needed) --------
EBS_DEVICE="/dev/xvdf"
MOUNT_POINT="/data"

while [ ! -e $EBS_DEVICE ]; do
  sleep 5
done

mkfs.ext4 $EBS_DEVICE || true
mkdir -p $MOUNT_POINT
mount $EBS_DEVICE $MOUNT_POINT || true

echo "$EBS_DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab

# -------- Clone repo --------
cd /opt
git clone https://github.com/YOUR_USERNAME/zabbix-monitoring-platform.git

cd zabbix-monitoring-platform/docker

# -------- Start stack --------
docker compose up -d