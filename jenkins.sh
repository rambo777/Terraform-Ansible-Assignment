#!/bin/bash
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
grep "jenkins.io" /etc/apt/sources.list
if [ $? -gt 0 ]
  then
    sudo sh -c "echo 'deb https://pkg.jenkins.io/debian-stable binary/' >> /etc/apt/sources.list"
    sudo apt-get update -y
    sudo apt-get install jenkins -y

fi
