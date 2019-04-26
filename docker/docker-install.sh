#!/bin/bash

#NTP INSTALL
sudo apt-get install ntp -y
sudo systemctl start ntpd
sudo systemctl enable ntpd

#DOCKER INSTALL
# step 1: 安装必要的一些系统工具
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# step 2: 安装GPG证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# Step 3: 写入软件源信息
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 4: 更新并安装 Docker-CE
sudo apt-get -y update
sudo apt-get -y install docker-ce=18.09.3~ce-0~ubuntu-xenial
#apt-cache madison docker-ce

sudo mkdir -p /etc/docker
sudo touch /etc/docker/daemon.json
sudo cat > /etc/docker/daemon.json << EOF
{ 
  "registry-mirrors": ["https://ezdhou8v.mirror.aliyuncs.com"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
