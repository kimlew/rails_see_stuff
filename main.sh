#! /usr/bin/env bash

# Script name: main.sh

# Description: This script runs all the other scripts required to copy files to 
# deployment machine, i.e., AWS, set up the deployment machine and launch the 
# See Stuff app.
# Create rails_see_stuff on AWS, create directory, deployment_files, copy 
# required files & folders from project directory to deployment_files, scp files & 
# folders from deployment_files to AWS.

# Note: To see meanings of these set flags, type: help set
# set -e  Exits immediately if a command exits with a non-zero status.
# set -x  Prints commands and their arguments as they are executed.

# Author: Kim Lew

set -e

# Prompt user for PEM_KEY and IP_ADDR. Then read in the variables.
read -resp "Type the full path to the .pem key: " PEM_KEY
echo
read -rep "Type the IP address: " IP_ADDR
echo
echo "SETTING UP See Stuff..."
echo

# These lines run on your local computer, e.g., Mac.
chmod u+x copy_files_to_aws.sh
./copy_files_to_aws.sh "${PEM_KEY}" "${IP_ADDR}"

# These next ssh lines run in a shell on Deployment Machine, e.g., AWS EC2 instance.
# TEST ssh with, e.g., ssh -i <full path>/key.pem ec2-user@34.213.67.66
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- chmod u+x setup_machine.sh \&\& \
  ./setup_machine.sh

echo "CLONING See Stuff repo from GitHub..."
# BAD since no Docker & Docker Compose: git clone --depth 1 --branch v2.0 https://github.com/kimlew/rails_see_stuff
# BETTER with Docker & Docker Compose: git clone <this branch>
# BEST & Later: Push Docker image to DockerHub.com & omit git clone step.
# ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- git clone -b see-stuff-in-docker https://github.com/kimlew/rails_see_stuff.git
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- /bin/sh <<EOF
  set -e
  if ! [ -d rails_see_stuff ]; then
    git clone -b see-stuff-in-docker https://github.com/kimlew/rails_see_stuff.git
  else
    cd rails_see_stuff
    git pull
  fi
EOF

# CHECK 1: Manually ssh & ls to verify files were copied to AWS.
# CHECK 2: Run these verification lines but UNCOMMENT later: 
echo "Current directory & files copied over are:"
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- pwd
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- ls -laht
echo
echo "Docker & Docker Compose versions installed are:"
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- docker -v
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- docker compose version
echo

# Run web app with docker compose command.
# Group nohup command with { } so only that 1 command runs in background.
# -v, --invert-match. Selected lines are those not matching any of the specified 
# patterns. -q , --quiet, --silent. Quiet mode: suppress normal output
echo "ADD if no docker group on EC2 instance. ADD also your user to group."
echo
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- /bin/sh <<'EOF'
  echo "The groups are: "
  groups
  echo
  if groups | grep -qv "docker"; then
    echo "Creating docker group & adding $USER to docker group."
    sudo groupadd docker || sudo newgrp docker &&
    echo
  echo "Adding $USER to docker group."
  sudo usermod -aG docker $USER
  fi
EOF
echo

echo "Running Docker Compose command to start app..."
echo
ssh -i "${PEM_KEY}" ubuntu@"${IP_ADDR}" -- cd rails_see_stuff \&\& \
\{ nohup docker compose up --build \& \} \&\& docker compose ps
echo
# In a Browser Tab: See the running app at the IP address, e.g., https://54.190.12.61/
