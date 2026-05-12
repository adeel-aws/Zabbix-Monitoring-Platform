#!/bin/bash
set -euxo pipefail

# -------- Install Docker --------
apt-get update -y
apt-get install -y docker.io docker-compose git

systemctl enable docker
systemctl start docker

# -------- Create data directories --------
mkdir -p /data/zabbix/mysql_data
chmod -R 777 /data/zabbix

# -------- Clone repo --------
cd /opt
git clone https://github.com/adeel-aws/Zabbix-Monitoring-Platform.git

cd Zabbix-Monitoring-Platform/docker

# -------- Start stack --------
docker-compose up -d