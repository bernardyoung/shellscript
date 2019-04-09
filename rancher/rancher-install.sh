#!/bin/bash
os=$(uname -s)
system=$(cat /etc/issue | awk '{print $1}')
version=$(cat /etc/issue | awk '{print $2}')
arch=$(uname -m)
kernel=$(uname -r)
echo os linux: $os
echo system Ubuntu: $system
echo version 16.04.5: $version
echo arch x86_64: $arch
echo kernel $kernel

function system_judgment () {
#判断操作系统类型
echo ================================
if [ $os == "Linux" ] && [ $arch == "x86_64" ]; then
#  echo "os is $os and arch $arch"
    if [ $system == "Ubuntu" ] && [ $((${version:0:2})) -eq 16 ] && [ $((${version:4:1})) -ge 4 ]; then
      docker_install
    else
      system_judgmenti_error
      echo "Ubuntu内核版本不符，当前内核为 $kernel"
    fi
  else
    system_judgmenti_error
    echo "操作系统架构不符,当前系统为: $os ,架构为: $arch"
fi
}

function docker_install () {
#docker安装
  echo docker_install........
  if [ $system == "Ubuntu" ]; then
    ubuntu_system_install
    ubuntu_docker_install
    #docker info
  else
    centos_system_install
    centos_docker_install
  fi
}

function ubuntu_system_install () {
  sudo ufw disable
  sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  sudo echo 'LANG="en_US.UTF-8"' >> /etc/profile;source /etc/profile

  #NTP INSTALL
  sudo apt-get install ntp -y
  sudo systemctl start ntp
  sudo systemctl enable ntp

  #kernel 性能调优
  cp -i /etc/sysctl.conf /etc/sysctl.conf.bak
  echo "" > /etc/sysctl.conf
  for i in `cat /etc/sysctl.conf.bak | grep -v ^\# | grep -v ^$`;
    do
      echo $i >> /etc/sysctl.conf
    done
  cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.ipv4.neigh.default.gc_thresh1=4096
net.ipv4.neigh.default.gc_thresh2=6144
net.ipv4.neigh.default.gc_thresh3=8192
EOF
  sudo sysctl -p
}

function ubuntu_docker_install () {
  # step 1: 安装必要的一些系统工具
  sudo apt-get update
  sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common gnupg-agent
  # step 2: 安装GPG证书
  curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  # Step 3: 写入软件源信息
  sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  # Step 4: 更新并安装 Docker-CE
  sudo apt-get -y update
  sudo apt-get -y install docker-ce=18.09.2~ce-0~ubuntu-xenial --allow-downgrades
  #apt-cache madison docker-ce

  sudo mkdir -p /etc/docker
  sudo cp ./daemon.json /etc/docker/daemon.json

  sudo systemctl daemon-reload
  sudo systemctl restart docker
}

function centos_system_install () {
  echo "CentOS system install .......加脚本 "
}
function centos_docker_install () {
  echo "CentOS docker install .......加脚本 "
}
function rancher_install () {
  #Rancher安装
  echo rancher_install
}


function system_judgmenti_error () {
  echo "操作系统要求Ubuntu、Redhat或CentOS"
  echo "Ubuntu版本要求为16.04+"
  echo "Redhat/CentOS要求 7.3.1611及以上，内核版本大于3.10.0-693.el7.x86_64"
}
function environment_check () {
  #检查操作系统环境
  echo environment_check
}

system_judgment
