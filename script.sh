#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
sudo apt update
sudo apt search openjdk
sudo apt install -y openjdk-11-jdk
#sudo apt install -y openjdk-11-jdk
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo echo password > /var/lib/jenkins/secrets/initialAdminPassword
