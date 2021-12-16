#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io amazon-ecr-credential-helper

sudo wget https://github.com/docker/compose/releases/download/1.28.5/docker-compose-Linux-x86_64 -O /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo addgroup ubuntu docker

echo "alias aws='docker run -it --rm -v ${HOME}/.aws:/root/.aws amazon/aws-cli'" >> .bash_aliases

mkdir -p /home/ubuntu/.docker
echo "{	\"credsStore\": \"ecr-login\" }" > /home/ubuntu/.docker/config.json
