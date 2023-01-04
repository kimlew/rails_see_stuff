#! /bin/bash

# Script name: setup_machine.sh

# Description: This script is called by main.sh. It sets up the web server on 
# the Deployment Machine/AWS, including installing Docker and Docker Compose on
# AWS, i.e., is a shell script that sets up EC2 instance for deployment of web 
# app on AWS.

# Author: Kim Lew

set -ex

ROOT_DIR='/home/ubuntu'
PROJECT_DIR='rails_see_stuff'

check_current_directory () {
  if [ ! -d "${THE_DIR}" ]; then
    cd "${THE_DIR}"
  fi
}

check_existing_project_directory () {
  if [ -d "${ROOT_DIR}"/"${PROJECT_DIR}" ]; then
    echo "A previous " "${PROJECT_DIR}" "exists. Removing it for a clean start state."
    echo 'The directory path is: ' "${ROOT_DIR}"/"${PROJECT_DIR}"
    rm -r "${ROOT_DIR:?}"/"${PROJECT_DIR}"
  fi
}

# Check if nano already installed & install if not. "" or check exit code?
check_if_nano_installed () {
  if ! command -v nano &> /dev/null; then
    sudo apt install nano -y
  fi
}

echo
echo "INSTALLING required packages plus Docker & Docker Compose ON VM on AWS..."
check_current_directory "${ROOT_DIR}"
check_existing_project_directory

sudo apt update && sudo apt upgrade -y
check_if_nano_installed

# --- Docker Installation ---
# Refer to: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04

# Install a few prerequisite packages which let apt use packages over HTTPS.
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

echo "CHECK curl verion..."
curl --version
echo
# Add the GPG key for the official Docker repository to your system.
# --batch - to disallow interactive commands
# -f - 
# -s - silent
# -L 
# -S - Show error

# curl -fsLS https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# https://docs.docker.com/engine/install/ubuntu/
# --batch - to get rid of error: gpg: cannot open '/dev/tty': No such device or address
echo "ADD official GPG key of Docker..."
sudo mkdir -p /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --dearmor -o /etc/apt/keyrings/docker.gpg
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo chmod a+r /usr/share/keyrings/docker-archive-keyring.gpg

# sudo mkdir -p /usr/share/keyrings
# GPG_KEY='/usr/share/keyrings/docker-archive-keyring.gpg'

sudo mkdir -p /etc/apt/keyrings
GPG_KEY='/etc/apt/keyrings/docker.gpg'

# CHECK if gpg key appears to be correct.
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg > "${GPG_KEY}"
# echo "SHOW key..."
# cat "${GPG_KEY}"
# echo
# sudo gpg --batch --dearmor -o "${GPG_KEY}"

if [ -f "${GPG_KEY}" ]; then
    echo "${GPG_KEY} exists. Removing for clean start state."
    sudo rm "${GPG_KEY}"
fi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --dearmor -o "${GPG_KEY}"
sudo apt update -y
sudo chmod a+r "${GPG_KEY}"
echo

# Add the Docker repository to APT sources.
echo "ADD the Docker repository to APT sources to set up the repository..."
# "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
echo "deb [arch=$(dpkg --print-architecture) signed-by=${GPG_KEY}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo
# Update existing list of packages again for the new packages to be recognized.
sudo apt update -y

# Make sure you are about to install from the Docker repo vs. the default Ubuntu
# repo, i.e., see that docker-ce is not installed & the candidate for installation
# is from the Docker repository for Ubuntu 22.04 (jammy). Example Output:
# docker-ce:
#   Installed: (none)
#   Candidate: 5:20.10.14~3-0~ubuntu-jammy
#   Version table:
#      5:20.10.14~3-0~ubuntu-jammy 500
#         500 https://download.docker.com/linux/ubuntu jammy/stable amd64 Packages
apt-cache policy docker-ce

# Install Docker. Docker should now be installed, the daemon started & the 
# process enabled to start on boot. Check that it’s running. If not, start Docker. 
sudo apt install docker-ce -y
# Automatically starts the docker daemon at boot: sudo systemctl enable docker
# vs. just starting it again at every boot: sudo systemctl start docker

# Check Docker is running, i.e Docker is installed, the daemon is started & 
# the process is enabled to start on boot.
echo
echo "CHECK Docker version & Docker STARTED after installation: "
docker -v
sudo service docker status || sudo service docker start
sudo chmod u+x /var/run/docker.sock
echo

# --- Docker Compose Installation ---
# Refer to: https://github.com/docker/compose
# Rename the relevant binary for your OS to docker-compose & copy it to 
# $HOME/.docker/cli-plugins
# Or to install it system-wide, copy it into 1 of these folders:
# /usr/local/lib/docker/cli-plugins OR /usr/local/libexec/docker/cli-plugins
# /usr/lib/docker/cli-plugins OR /usr/libexec/docker/cli-plugins
# (might require making the downloaded file executable with chmod +x)

# Also Note: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04
# Note: Starting with Docker Compose v2, Docker has migrated towards using the 
# compose CLI plugin command (& away from the original docker-compose as 
# documented in our previous Ubuntu 20.04 version of this tutorial. While the 
# installation differs, in general the actual usage involves dropping the hyphen
# from docker-compose calls to become docker compose. For full compatibility 
# details, check the official Docker documentation on command compatibility 
# between the new compose & the old docker-compose.

mkdir -p ~/.docker/cli-plugins/
sudo curl -SL https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
sudo chmod +x ~/.docker/cli-plugins/docker-compose
echo "CHECK Docker Compose version installed: "
docker compose version
echo

# At this point at the end of script, you are passed back to main.sh & onto
# next command with docker compose up --build (which in turn, runs launch_app.sh 
# & runs the See Stuff web app).
