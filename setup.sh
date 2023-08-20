#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Add the Rapid7 repository for Metasploit
echo "deb http://apt.metasploit.com/ lucid main" > /etc/apt/sources.list.d/metasploit-framework.list
wget -qO- http://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add -

# Update package repositories
apt update

# Install required packages
apt install -y metasploit-framework sqlmap crackmapexec xrdp dnsrecon fierce

# Prompt for new username
read -p "Enter the new username: " NEW_USERNAME

# Prompt for new password
read -s -p "Enter the new password: " NEW_PASSWORD
echo

# Create a new user with sudo privileges
adduser --disabled-password --gecos "" $NEW_USERNAME
usermod -aG sudo $NEW_USERNAME
echo "$NEW_USERNAME:$NEW_PASSWORD" | chpasswd

# Generate new SSH keys for the new user
SSH_DIR="/home/$NEW_USERNAME/.ssh"
sudo -u $NEW_USERNAME mkdir -p $SSH_DIR
sudo -u $NEW_USERNAME ssh-keygen -t rsa -b 4096 -f $SSH_DIR/id_rsa -N ""

echo "Installation and configuration completed."

exit 0
