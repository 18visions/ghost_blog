#!/bin/bash -xe

apt update -y && apt upgrade -y
apt install -y zip unzip bind-utils htop python3-pip
python3 -m pip install ansible

cd /root/
aws s3 cp s3://${s3_bucket}/ghost/ghost-ansible.zip

unzip ghost-ansible.zip

echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg
hostnamectl set-hostname ${hostname}

/usr/local/bin/ansible-playbook -i "127.0.0.1," --connection=local install_ghost.yml
